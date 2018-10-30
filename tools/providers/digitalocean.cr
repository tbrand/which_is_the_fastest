require "json"
require "option_parser"
require "io/memory"
require "yaml"
require "kiwi/file_store"
require "admiral"
require "ssh2"

# Wrapper around doctl tool
# -> by default, parse json output
# -> could also return return value
def execute(cmd, output : Bool = true)
  error = IO::Memory.new
  output = IO::Memory.new

  retval = Process.run(cmd, shell: true, output: output, error: error)

  # if no output
  if output == false
    return retval
  end

  # if stderr is not empty
  if error.size > 0
    msg = error.to_s.strip
    error.close
    output.close
    raise msg
  end
  ret = JSON.parse(output.to_s.strip)
  output.close
  error.close
  ret
end

class App < Admiral::Command
  class Create < Admiral::Command
    define_flag language : String, description: "language selected, to set-up environment", required: true, short: l
    define_flag framework : String, description: "framework that will eb set-up", required: true, short: f

    # ssh configuration
    define_flag key : String, description: "ssh key fingerprint", required: true, short: k

    # droplet configuration
    define_flag image : String, description: "droplet image / os", short: i, default: "fedora-28-x64"
    define_flag region : String, description: "droplet region", short: r, default: "fra1"
    define_flag size : String, description: "droplet size (default the cheaper)", short: s, default: "s-1vcpu-1gb"

    def run
      database = Kiwi::FileStore.new("config.db")
      config = YAML.parse(File.read("#{flags.language}/config.yml"))

      template = config["providers"]["digitalocean"]["config"]
      f = File.open("/tmp/template.yml", "w")
      f.puts("#cloud-config")
      f.puts(YAML.dump(template).gsub("---", "")) # cloud-init does not accepts start-comment in yaml
      f.close
      instances = execute("doctl compute droplet create #{flags.framework} --image #{flags.image} --region #{flags.region} --size #{flags.size} --ssh-keys #{flags.key} --user-data-file /tmp/template.yml")
      instance_id = instances[0]["id"]
      sleep 1 # wait droplet's network to be available
      instance = execute("doctl compute droplet get #{instance_id}")
      ip = instance[0]["networks"]["v4"][0]["ip_address"]
      database.set("#{flags.framework.to_s.upcase}_USERNAME", "root")
      database.set("#{flags.framework.to_s.upcase}_IP", ip)
    end
  end

  class Upload < Admiral::Command
    define_flag language : String, description: "language selected, to set-up environment", required: true, short: l
    define_flag framework : String, description: "framework that will eb set-up", required: true, short: f

    # ssh configuration
    define_flag key : String, description: "ssh key fingefile", required: true, short: k

    def run
      database = Kiwi::FileStore.new("config.db")
      username = database.get("#{flags.framework.to_s.upcase}_USERNAME")
      ip = database.get("#{flags.framework.to_s.upcase}_IP")

      SSH2::Session.open(ip.to_s, 22) do |session|
        session.login_with_pubkey(username.to_s, flags.key)

        # Create directory
        session.open_session do |ch|
          ch.command("mkdir -p /usr/src/app")
          IO.copy(ch, STDOUT)
        end

        # Upload files
        arguments.each do |file|
          path = File.join(Dir.current, flags.language.to_s, flags.framework.to_s, file)
          session.scp_send(File.join("/usr/src/app", file.to_s), 0o0644, File.size(path)) do |ch|
            ch.puts File.read(path)
          end
        end
      end
    end
  end

  class Exec < Admiral::Command
    define_flag language : String, description: "language selected, to set-up environment", required: true, short: l
    define_flag framework : String, description: "framework that will eb set-up", required: true, short: f

    # ssh configuration
    define_flag key : String, description: "ssh key fingefile", required: true, short: k

    def run
      database = Kiwi::FileStore.new("config.db")
      username = database.get("#{flags.framework.to_s.upcase}_USERNAME")
      ip = database.get("#{flags.framework.to_s.upcase}_IP")

      SSH2::Session.open(ip.to_s, 22) do |session|
        session.login_with_pubkey(username.to_s, flags.key)

        session.open_session do |ch|
          arguments.each do |cmd|
            ch.command("cd /usr/src/app && #{cmd}")
            IO.copy(ch, STDOUT)
          end
        end
      end
    end
  end

  class Delete < Admiral::Command
    define_flag language : String, description: "language selected, to set-up environment", required: true, short: l
    define_flag framework : String, description: "framework that will eb set-up", required: true, short: f

    def run
      retval execute("doctl compute droplet delete #{flags.framework} --force")

      if retval
        raise "Failed to delete #{flags.framework} droplet"
      end
    end
  end

  register_sub_command create : Create, description "Create droplet for specific language"
  register_sub_command upload : Upload, description "Upload file (or folders) to previously created droplet"
  register_sub_command exec : Exec, description "Execute command on previously created droplet"
  register_sub_command delete : Delete, description "Delet previously created droplet"

  def run
    puts "help"
  end
end

App.run
