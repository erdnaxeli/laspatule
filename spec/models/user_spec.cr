require "./spec_helper"

describe Laspatule::Models::User do
  describe ".new" do
    it "creates a new User" do
      user = Laspatule::Models::User.new(id: 1, name: "user")
      user.id.should eq(1)
      user.name.should eq("user")
    end
  end

  describe "#to_json" do
    it "serializes an User to json" do
      json = USER.to_json
      json.should eq(%({"id":1,"name":"user"}))
    end
  end
end

describe Laspatule::Models::UserWithPassword do
  describe ".new" do
    [
      {id: 1, enabled: true, name: "user", email: "email", password: nil, reinit_token: nil, reinit_at: nil},
      {id: 1, enabled: false, name: "user", email: "email", password: "mdp", reinit_token: nil, reinit_at: nil},
      {id: 1, enabled: true, name: "user", email: "email", password: "mdp", reinit_token: "token", reinit_at: Time.local},
    ].each do |args|
      it "creates a new UserWithPassword" do
        user = Laspatule::Models::UserWithPassword.new(**args)
        user.id.should eq(args["id"])
        user.enabled.should eq(args["enabled"])
        user.name.should eq(args["name"])
        user.email.should eq(args["email"])
        user.password.should eq(args["password"])
        user.reinit_token.should eq(args["reinit_token"])
        user.reinit_at.should eq(args["reinit_at"])
      end
    end
  end
end
