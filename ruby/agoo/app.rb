# frozen_string_literal: true

require 'agoo'

Agoo::Log.configure(dir: '',
                    console: true,
                    classic: true,
                    colorize: true,
                    states: {
                      INFO: false,
                      DEBUG: false,
                      connect: false,
                      request: false,
                      response: false,
                      eval: false,
                      push: false
                    })

worker_count = `nproc`.to_i
worker_count = 1 if worker_count < 1
Agoo::Server.init(3000, '.', thread_count: 0, worker_count: worker_count, poll_timeout: 0.1)

# Empty response.
class Empty
  def self.call(_req)
    [200, {}, []]
  end

  def static?
    true
  end
end

# Reflects the id as the returned value.
class Reflect
  def self.call(req)
    [200, {}, [req['PATH_INFO'][6..]]]
  end
end

# post response.
class Post
  def self.call(_req)
    [200, {}, []]
  end
end

Agoo::Server.handle(:GET, '/', Empty)
Agoo::Server.handle(:GET, '/user/*', Reflect)
Agoo::Server.handle(:POST, '/user', Post)

Agoo::Server.start
