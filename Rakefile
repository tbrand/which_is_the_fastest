# frozen_string_literal: true

require 'dotenv'
require 'active_support'

MANIFESTS = {
  container: '.Dockerfile',
  build: '.Makefile'
}.freeze

Dotenv.load

class ::Hash
  def recursive_merge(hash)
    merge!(hash) { |_, old, new| old.instance_of?(Hash) ? old.recursive_merge(new) : new }
  end
end

def get_config_from(directory, engines_as_list: true)
  main_config = YAML.safe_load(File.open(File.join(directory, '..', '..', 'config.yaml')))

  language_config = YAML.safe_load(File.open(File.join(directory, '..', 'config.yaml')))

  framework_config = YAML.safe_load(File.open(File.join(directory, 'config.yaml')))

  config = main_config.recursive_merge(language_config).recursive_merge(framework_config)

  unless engines_as_list
    config['framework']['engines'] = config.dig('framework', 'engines').map do |row|
      if row.is_a?(String) && config.dig('language', 'engines', row)
        { row => config.dig('language', 'engines', row) }
      else
        row
      end
    end
  end

  skippable_keys = framework_config['framework'].select { |_k, v| v.nil? }.keys
  skippable_keys.each do |skippable_key|
    config['framework'].except!(skippable_key)
    config['language'].except!(skippable_key)
  end

  config
end

def default_provider
  if RbConfig::CONFIG['host_os'] =~ /linux/
    'docker'
  else
    'docker-desktop'
  end
end

def custom_config(dict1, dict2, dict3)
  keys = dict1.keys << dict2.keys << dict3.keys
  data = {}
  keys.flatten!.uniq.each do |key|
    next if %w[version engines website github].include?(key)

    data[key] = override_or_merge(dict3[key], dict2[key], dict1[key])
  end
  data
end

def override_or_merge(value3, value2, value1)
  value = value3
  if value
    if value2
      case value2
      when Array
        value.unshift(*value2)
      when String
        value = value2
      end
    end
  else
    value = value2
  end
  if value
    if value1
      case value1
      when Array
        value.unshift(*value1)
      when String
        value = value1
      end
    end
  else
    value = value1
  end

  value
end

def commands_for(language, framework, variant, provider = default_provider)
  config = YAML.safe_load(File.read('config.yaml'))

  directory = Dir.pwd
  main_config = YAML.safe_load(File.open(File.join(directory, 'config.yaml')))
  language_config = YAML.safe_load(File.open(File.join(directory, language, 'config.yaml')))
  framework_config = YAML.safe_load(File.open(File.join(directory, language, framework, 'config.yaml')))
  app_config = main_config.recursive_merge(language_config).recursive_merge(framework_config)
  options = { language: language, framework: framework, variant: variant,
              manifest: "#{MANIFESTS[:container]}.#{variant}" }
  commands = { build: [], collect: [], clean: [] }

  # Compile first, only for non containers

  if app_config.key?('binaries')
    commands << "docker build -f #{MANIFESTS[:container]} -t #{language}.#{framework} ."
    commands << "docker run -td #{language}.#{framework} > cid.txt"
    app_config['binaries'].each do |out|
      if out.count(File::Separator).positive?
        FileUtils.mkdir_p(File.join(directory, File.dirname(out)))
        commands[:build] << "docker cp `cat cid.txt`:/opt/web/#{File.dirname(out)} ."
      else
        commands[:build] << "docker cp `cat cid.txt`:/opt/web/#{out} #{out}"
      end
    end
  end

  config['providers'][provider]['build'].each do |cmd|
    commands[:build] << Mustache.render(cmd, options).to_s
  end

  config['providers'][provider]['metadata'].each do |cmd|
    commands[:build] << Mustache.render(cmd, options).to_s
  end

  if app_config.key?('bootstrap') && config['providers'][provider].key?('exec')
    remote_command = config['providers'][[provider]]['exec']
    app_config['bootstrap'].each do |cmd|
      commands[:build] << Mustache.render(remote_command, options.merge!(command: cmd)).to_s
    end
  end

  if config.dig('providers', provider).key?('reboot')
    commands[:build] << config.dig('providers', provider, 'reboot')
    commands[:build] << 'sleep 30'
  end

  commands[:build] << "curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat #{language}/#{framework}/ip-#{variant}.txt`:3000 -v"

  commands[:collect] << "HOSTNAME=`cat #{language}/#{framework}/ip-#{variant}.txt` ENGINE=#{variant} LANGUAGE=#{language} FRAMEWORK=#{framework} DATABASE_URL=#{ENV['DATABASE_URL']} bundle exec rake collect"

  config.dig('providers', provider, 'clean').each do |cmd|
    commands[:clean] << Mustache.render(cmd, options).to_s
  end

  commands
end

def create_dockerfile(directory, engine, config)
  generic_template = File.join(Dir.pwd, directory, '..', 'Dockerfile')
  custom_template = File.join(Dir.pwd, directory, '..', "#{engine}.Dockerfile")
  template = if File.exist?(custom_template)
               custom_template
             else
               generic_template
             end
  files = []

  Dir.glob(config['files']).each do |file|
    variant_file = file.gsub(directory, File.join(directory, ".#{engine}"))

    target = if file.include?(".#{engine}")
               file.gsub(".#{engine}/", '').gsub("#{directory}/", '')
             else
               file.gsub("#{directory}/", '')
             end

    source = if File.exist?(variant_file)
               variant_file
             else
               file
             end

    files << { source: source.gsub("#{directory}/", ''), target: target }
  end

  File.open(File.join(directory, ".Dockerfile.#{engine}"), 'w') do |f|
    f.write(Mustache.render(File.read(template), config.merge('files' => files, 'environment' => config['environment']&.map do |k, v|
                                                                                                   "#{k}=#{v}"
                                                                                                 end)))
  end
end

desc 'Create Dockerfiles'
task :config do
  Dir.glob(['ruby/*/config.yaml', 'javascript/*/config.yaml', 'php/*/config.yaml']).each do |path|
    directory = File.dirname(path)
    config = get_config_from(directory, engines_as_list: false)
    raise "missing engine for #{directory}" unless config.dig('framework', 'engines')

    config.dig('framework', 'engines').each do |engine|
      engine.each do |name, data|
        variables = custom_config(config['language'], config['framework'], data)
        variables['files'].each { |f| f.prepend(directory, File::SEPARATOR) unless f.start_with?(directory) }

        create_dockerfile(directory, name, variables)
      end
    end

    language, framework = directory.split(File::SEPARATOR)

    makefile = File.open(File.join(language, framework, MANIFESTS[:build]), 'w')

    config.dig('framework', 'engines').each do |engine|
      engine.each do |name, _|
        commands_for(language, framework, name).each do |target, commands|
          makefile.write("#{target}.#{name}:\n")
          commands.each do |command|
            makefile.write("\t #{command}\n")
          end
        end
      end
    end

    names = config.dig('framework', 'engines').flat_map(&:keys)
    command = names.flat_map { |n| ["build.#{n}", "collect.#{n}", "clean.#{n}"] }.join(' ')

    makefile.write("run-all : #{command}\n")

    makefile.close
  end
end

desc 'Clean unused file'
task :clean do
  Dir.glob('*/*/.gitignore').each do |ignore_file|
    directory = File.dirname(ignore_file)

    File.foreach(ignore_file) do |line|
      line.strip!
      next if line.start_with?('!')
      next if line.start_with?('#')
      next if line.start_with?('.env')
      next if line.empty?

      Dir.glob(File.join(directory, line)).each do |path|
        if File.exist?(path)
          if File.file?(path)
            warn "Delting file #{path}"
            File.delete(path)
          elsif File.directory?(path)
            warn "Deleting directory #{path}"
            FileUtils.rm_rf(path)
          end
        end
      end
    end
  end
end

Dir.glob('.tasks/*.rake').each { |r| load r }
