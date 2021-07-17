# frozen_string_literal: true

require 'pg'
require 'mustache'
require 'yaml'
require 'active_support/number_helper'
require 'dotenv'
require 'etc'

Dotenv.load

class ::Hash
  def recursive_merge(h)
    merge!(h) { |_key, _old, _new| _old.instance_of?(Hash) ? _old.recursive_merge(_new) : _new }
  end
end

SQL = %(
    SELECT CONCAT(f.id, e.id) AS id, l.label AS language, f.label AS framework, c.level, k.label, e.label AS engine, avg(v.value) AS value
        FROM frameworks AS f
            JOIN metrics AS m ON f.id = m.framework_id
            JOIN engines AS e ON e.id = m.engine_id
            JOIN values AS v ON v.id = m.value_id
            JOIN concurrencies AS c on c.id = m.concurrency_id
            JOIN languages AS l on l.id = f.language_id
            JOIN keys AS k ON k.id = v.key_id
                GROUP BY 1,2,3,4,5,6
)

def compute(data)
  errors = data['http_errors'].to_d
  duration = data['duration_ms'].to_d / 1_000_000
  requests = data['total_requests'].to_d

  (requests - errors) / duration
end

namespace :db do
  task :export do
    raise 'Please provide a database' unless ENV['DATABASE_URL']

    frameworks = {}
    db = PG.connect(ENV['DATABASE_URL'])
    db.exec(SQL) do |result|
      result.each do |row|
        id, framework, language = row.values_at('id', 'framework', 'language')
        unless frameworks.key?(id)
          frameworks[id] = {
            language: language,
            framework: framework,
            metrics: { concurrency_64: {}, concurrency_256: {}, concurrency_512: {} }
          }
        end
        framework_config = YAML.safe_load(File.read(File.join(language, framework, 'config.yaml')))
        language_config = YAML.safe_load(File.read(File.join(language, 'config.yaml')))

        key = "concurrency_#{row['level']}".to_sym
        frameworks[id][:metrics][key].merge!(row['label'] => row['value'])
        frameworks[id].merge!(framework_config['framework'].transform_keys!(&'framework_'.method(:+)))
        frameworks[id].merge!(language_config['provider']['default'].transform_keys!(&'language_'.method(:+)))

        if framework_config['framework'].key?('framework_name')
          frameworks[id].merge!(framework: framework_config['framework']['framework_name'])
        end
        scheme = 'https'
        scheme = 'http' if framework_config['framework'].key?('unsecure')
        website = if framework_config['framework'].key?('framework_github')
                    "github.com/#{framework_config['framework']['framework_github']}"
                  elsif framework_config['framework'].key?('framework_gitlab')
                    "gitlab.com/#{framework_config['framework']['framework_gitlab']}"
                  else
                    (framework_config['framework']['framework_website']).to_s
                  end
        frameworks[id].merge!(framework_website: "#{scheme}://#{website}")
      end
    end
    db.close
    template = %Q{
|    | Language | Framework | Speed (64) | Speed (256) | Speed (512) |
|----|----------|-----------|-----------:|------------:|------------:|
{{#results}}
| {{id}} | {{language}} ({{language_language}})| [{{framework}}]({{framework_website}}) ({{framework_version}}) | {{concurrency_64}} | {{concurrency_256}} | {{concurrency_512}} |
{{/results}}
}

    results = []

    frameworks.each do |id, row|
      concurrency = compute(row[:metrics][:concurrency_64])
      if concurrency.nan?
        warn "Skipped #{row[:framework]} - Failure"
        next
      end
      if concurrency.zero?
        warn "Skipped #{row[:framework]} - O requests OK"
        next
      end
      row.merge!(
        id: id.to_i,
        concurrency_64: compute(row[:metrics][:concurrency_64]),
        concurrency_256: compute(row[:metrics][:concurrency_256]),
        concurrency_512: compute(row[:metrics][:concurrency_512])
      )
      results << row
    end
    c = 0
    results.sort! { |x, y| y[:concurrency_64].to_f <=> x[:concurrency_64].to_f }.map do |row|
      c += 1

      row.merge!(
        id: c,
        concurrency_64: ActiveSupport::NumberHelper.number_to_delimited('%.2f' % row[:concurrency_64], delimiter: ' '),
        concurrency_256: ActiveSupport::NumberHelper.number_to_delimited('%.2f' % row[:concurrency_256],
                                                                         delimiter: ' '),
        concurrency_512: ActiveSupport::NumberHelper.number_to_delimited('%.2f' % row[:concurrency_512], delimiter: ' ')
      )
    end
    $stdout.write(Mustache.render(template, { results: results, date: Date.today, docker_version: `docker --version` }))
    
  end
  task :raw_export do
    raise 'Please provide a database' unless ENV['DATABASE_URL']

    data = { metrics: [], frameworks: [], languages: [] }
    db = PG.connect(ENV['DATABASE_URL'])
    db.exec("select row_to_json(t) from (#{SQL}) as t") do |result|
      result.each do |row|
        info = JSON.parse(row['row_to_json'], symbolize_names: true)
        framework_id = info.delete :id
        info[:framework_id] = framework_id
        language = info.delete :language
        framework = info.delete :framework
        framework_config = YAML.safe_load(File.read(File.join(language, framework, 'config.yaml')))
        language_config = YAML.safe_load(File.read(File.join(language, 'config.yaml')))
        scheme = 'https'
        scheme = 'http' if framework_config['framework'].key?('unsecure')
        website = if framework_config['framework'].key?('github')
                    "github.com/#{framework_config['framework']['github']}"
                  elsif framework_config['framework'].key?('gitlab')
                    "gitlab.com/#{framework_config['framework']['gitlab']}"
                  else
                    (framework_config['framework']['website']).to_s
                  end
        unless data[:frameworks].map { |row| row[:id] }.to_a.include?(framework_id)
          data[:frameworks] << {
            id: framework_id,
            version: framework_config.dig('framework', 'version'),
            label: framework,
            engine: info[:engine],
            language: language,
            website: "#{scheme}://#{website}"
          }
        end
        unless data[:languages].map { |row| row[:label] }.to_a.include?(language)
          data[:languages] << {
            label: language,
            version: language_config.dig('language', 'version'),
          }
        end
        data[:metrics] << info
        next
      end
    end
    data.merge!(updated_at: Time.now.utc)
    data.merge!(hardware: { cpus: Etc.nprocessors, memory: 16_282_676, cpu_name: 'AMD FX-8320E Eight-Core Processor',
                            os: Etc.uname })
    File.open('data.json', 'w').write(JSON.pretty_generate(data))
    File.open('data.min.json', 'w').write(data.to_json)
  end
end
