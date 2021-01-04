require "kemal"

require "./api/*"
require "./config"
require "./repositories/db"

config = Laspatule::Config.read("config.yaml")
db = Laspatule::Repositories::DB.new(config.db)
ingredients_repo = Laspatule::Repositories::DB::Ingredients.new(db)

serve_static false

after_all do |env|
  env.response.content_type = "application/json"
end

Laspatule::API::Ingredients.setup(ingredients_repo)

Kemal.run
