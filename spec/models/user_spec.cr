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
