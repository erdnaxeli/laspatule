require "kemal"

module Laspatule::API::User
  def self.setup(user_repo, mail)
    post "/user/auth" do |env|
      email = env.params.json["email"].as(String)
      password = env.params.json["password"].as(String)

      service = Laspatule::Services::Users.new(user_repo, mail)
      if user = service.auth(email, password)
        access_token = service.create_access_token(user)
        access_token.to_json
      else
        halt env, status_code: 401
      end
    end
  end
end
