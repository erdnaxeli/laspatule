require "kemal"

module Laspatule::API::User
  def self.setup(service)
    get "/user" do |env|
      access_token = env.get("access_token").as(String)
      if user = service.get_by_access_token?(access_token)
        user.to_json
      else
        halt env, status_code: 401
      end
    end

    post "/user/auth" do |env|
      email = env.params.json["email"].as(String)
      password = env.params.json["password"].as(String)

      if user = service.auth(email, password)
        access_token = service.create_access_token(user)
        access_token.to_json
      else
        halt env, status_code: 401
      end
    end
  end
end
