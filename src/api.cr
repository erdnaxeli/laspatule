require "kemal"

require "./laspatule"

config = Laspatule::Config.read("config.yaml")
db = Laspatule::Repositories::DB.open(config.db)
Laspatule::Repositories::DB.migrate(db)
ingredients_repo = Laspatule::Repositories::DB::Ingredients.new(db)
recipes_repo = Laspatule::Repositories::DB::Recipes.new(db)
users_repo = Laspatule::Repositories::DB::Users.new(db)
mail = Laspatule::Services::Mail::Mailgun.new(config.mail)
users_service = Laspatule::Services::Users.new(users_repo, mail)

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

# Empty handler to not respond with a 404.
options "/*" { }

class CorsHandler < Kemal::Handler
  def call(env)
    env.response.headers["Access-Control-Allow-Origin"] = "*"
    env.response.headers["Access-Control-Allow-Headers"] = "*"
    call_next(env)
  end
end

class AuthHandler < Kemal::Handler
  exclude ["/swagger", "/v3/swagger.json"], "GET"
  exclude ["/user/auth"], "POST"
  exclude ["/*"], "OPTIONS"

  @service : Laspatule::Services::Users

  def initialize(users_repo, mail)
    @service = Laspatule::Services::Users.new(users_repo, mail)
  end

  def call(env)
    return call_next(env) if exclude_match?(env)

    if authorization = env.request.headers["authorization"]?
      if authorization =~ /^Bearer ([^ ]+)$/
        _, access_token = authorization.split(' ')
        if user = @service.get_by_access_token?(access_token)
          env.set "access_token", access_token
          env.set "user_id", user.id

          return call_next(env)
        end
      end
    end

    env.response.status_code = 401
    env.response.headers["WWW-authenticate"] = "Bearer"
    env.response.close
  end
end

add_handler CorsHandler.new
add_handler AuthHandler.new(users_repo, mail)

Laspatule::API::Doc.setup
Laspatule::API::Ingredients.setup(ingredients_repo)
Laspatule::API::Recipes.setup(recipes_repo)
Laspatule::API::User.setup(users_service)

Kemal.run
