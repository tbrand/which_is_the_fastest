# frozen_string_literal: true

require 'open3'
require 'csv'
require 'etc'
require 'bigdecimal/util'

PIPELINE = {
  GET: File.join(Dir.pwd, 'pipeline.lua'),
  POST: File.join(Dir.pwd, 'pipeline_post.lua')
}.freeze

def insert(db, framework_id, metric, value, concurrency_level_id, engine_id)
  res = db.query('INSERT INTO keys (label) VALUES ($1) ON CONFLICT (label) DO UPDATE SET label = $1 RETURNING id',
                 [metric])

  metric_id = res.first['id']

  res = db.query('INSERT INTO values (key_id, value) VALUES ($1, $2) RETURNING id', [metric_id, value])
  value_id = res.first['id']

  db.query('INSERT INTO metrics (value_id, framework_id, concurrency_id, engine_id) VALUES ($1, $2, $3, $4)',
           [value_id, framework_id, concurrency_level_id, engine_id])
end

task :collect do
  threads = ENV.fetch('THREADS') { Etc.nprocessors }
  duration = ENV.fetch('DURATION', 10)
  language = ENV.fetch('LANGUAGE') { raise 'please provide the language' }
  framework = ENV.fetch('FRAMEWORK') { raise 'please provide the target framework' }
  concurrencies = ENV.fetch('CONCURRENCIES', '10')
  routes = ENV.fetch('ROUTES', 'GET:/')
  database = ENV.fetch('DATABASE_URL') { raise 'please provide a DATABASE_URL (pg only)' }
hostname = ENV.fetch('HOSTNAME')
engine = ENV.fetch('ENGINE')

  `wrk -H 'Connection: keep-alive' -d 5s -c 8 --timeout 8 -t #{threads} http://#{hostname}:3000`
  `wrk -H 'Connection: keep-alive' -d #{duration}s -c 256 --timeout 8 -t #{threads} http://#{hostname}:3000`

  db = PG.connect(database)

  res = db.query(
    'INSERT INTO languages (label) VALUES ($1) ON CONFLICT (label) DO UPDATE SET label = $1 RETURNING id', [language]
  )
  language_id = res.first['id']

  res = db.query(
    'INSERT INTO engines (label) VALUES ($1) ON CONFLICT (label) DO UPDATE SET label = $1 RETURNING id', [engine]
  )
  engine_id = res.first['id']

  res = db.query(
    'INSERT INTO frameworks (language_id, label) VALUES ($1, $2) ON CONFLICT (language_id, label) DO UPDATE SET label = $2 RETURNING id', [
      language_id, framework
    ]
  )
  framework_id = res.first['id']

  routes.split(',').each do |route|
    method, uri = route.split(':')

    concurrencies.split(',').each do |concurrency|
      res = db.query(
        'INSERT INTO concurrencies (level) VALUES ($1) ON CONFLICT (level) DO UPDATE SET level = $1 RETURNING id', [concurrency]
      )

      concurrency_level_id = res.first['id']

      command = format(
        "wrk -H 'Connection: keep-alive' --connections %<concurrency>s --threads %<threads>s --duration %<duration>s --timeout 1 --script %<pipeline>s http://%<hostname>s:3000#{uri}", concurrency: concurrency, threads: threads, duration: duration, pipeline: PIPELINE[method.to_sym], hostname: hostname
      )

      Open3.popen3(command) do |_, stdout, stderr|
        wrk_output = stdout.read
        lua_output = stderr.read
        lua_keys = ['duration_ms', 'total_requests', 'total_requests_per_s', 'total_bytes_received',
                    'socket_connection_errors', 'socket_read_errors', 'socket_write_errors',
                    'http_errors', 'request_timeouts', 'minimum_latency', 'maximum_latency',
                    'average_latency', 'standard_deviation', 'percentile_50',
                    'percentile_75', 'percentile_90', 'percentile_99', 'percentile_99.999']

        pp '================'
        pp "CMD : #{command}"
        pp '================'
        pp "OUT : #{wrk_output}"
        pp '================'
        pp "LUA : #{lua_keys.join(',')}"
        pp "LUA : #{lua_output}"

        info = lua_output.split(',')
        lua_keys.each_with_index do |key, index|
          insert(db, framework_id, key, info[index].to_d, concurrency_level_id, engine_id)
        end
      end
    end
  end
  db.close
end
