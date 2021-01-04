require "kemal"

require "./api/*"

serve_static false

after_all do |env|
  env.response.content_type = "application/json"
end

Kemal.run
