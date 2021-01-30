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

before_post do |env|
  if content_type = env.request.headers["content-type"]?
    if content_type !~ /(^|:)application\/json($|;)/
      halt env, status_code: 415
    end
  else
    halt env, status_code: 415
  end
end

after_all do |env|
  env.response.content_type = "application/json"
  env.response.headers.add("Access-Control-Allow-Origin", "*")
  env.response.headers.add("Access-Control-Allow-Headers", "*")
end

# Empty handler to not respond with a 404.
options "/*" { }

class AuthHandler < Kemal::Handler
  exclude ["/user/auth"], "POST"
  exclude ["/*"], "OPTIONS"

  def call(env)
    return call_next(env) if exclude_match?(env)

    if authorization = env.request.headers["authorization"]?
      if authorization =~ /^Bearer ([^ ]+)$/
        _, access_token = authorization.split(' ')

        env.set "access_token", access_token

        call_next(env)
      end
    end
  end
end

add_handler AuthHandler.new

Laspatule::API::Doc.setup
Laspatule::API::Ingredients.setup(ingredients_repo)
Laspatule::API::Recipes.setup(recipes_repo)
Laspatule::API::User.setup(users_repo, mail)

Kemal.run
