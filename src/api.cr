require "kemal"

require "./laspatule"

config = Laspatule::Config.read("config.yaml")
db = Laspatule::Repositories::DB.open(config.db)
Laspatule::Repositories::DB.migrate(db)
ingredients_repo = Laspatule::Repositories::DB::Ingredients.new(db)

serve_static false

error 404 { }

after_all do |env|
  env.response.content_type = "application/json"
end

Laspatule::API::Ingredients.setup(ingredients_repo)
Laspatule::API::Doc.setup

Kemal.run
