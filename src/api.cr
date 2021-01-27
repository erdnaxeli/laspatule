require "kemal"

require "./laspatule"

config = Laspatule::Config.read("config.yaml")
db = Laspatule::Repositories::DB.open(config.db)
Laspatule::Repositories::DB.migrate(db)
ingredients_repo = Laspatule::Repositories::DB::Ingredients.new(db)
recipes_repo = Laspatule::Repositories::DB::Recipes.new(db)
mail = Laspatule::Services::Mail::Mailgun.new(config.mail)
users_repo = Laspatule::Repositories::DB::Users.new(db)

serve_static false

error 404 { }

after_all do |env|
  env.response.content_type = "application/json"
end

Laspatule::API::Doc.setup
Laspatule::API::Ingredients.setup(ingredients_repo)
Laspatule::API::Recipes.setup(recipes_repo)
Laspatule::API::User.setup(users_repo, mail)

Kemal.run
