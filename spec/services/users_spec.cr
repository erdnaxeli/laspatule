require "./spec_helper"

describe Laspatule::Services::Users do
  describe "#auth" do
    it "returns nil when the user is not found" do
      repo = UserRepoMock.new(
        get_by_email_return: Laspatule::Repositories::Users::UserNotFoundError.new
      )
      service = Laspatule::Services::Users.new(repo)

      result = service.auth(email: "test", password: "test")

      result.should be_nil
    end

    it "returns nil when the user is not enabled" do
      repo = UserRepoMock.new(
        get_by_email_return: Laspatule::Models::UserWithPassword.new(
          id: 1,
          enabled: false,
          name: "user",
          email: "garbage",
          password: nil,
        )
      )
      service = Laspatule::Services::Users.new(repo)

      result = service.auth(email: "test", password: "test")

      result.should be_nil
    end

    it "returns nil when the user's password is empty'" do
      repo = UserRepoMock.new(
        get_by_email_return: Laspatule::Models::UserWithPassword.new(
          id: 1,
          enabled: true,
          name: "user",
          email: "garbage",
          password: nil,
        )
      )
      service = Laspatule::Services::Users.new(repo)

      result = service.auth(email: "test", password: "test")

      result.should be_nil
    end

    it "returns nil when the user's password is incorrect'" do
      hash = Crypto::Bcrypt::Password.create("test", cost: 4)
      repo = UserRepoMock.new(
        get_by_email_return: Laspatule::Models::UserWithPassword.new(
          id: 1,
          enabled: true,
          name: "user",
          email: "garbage",
          password: hash.to_s,
        )
      )
      service = Laspatule::Services::Users.new(repo)

      result = service.auth(email: "test", password: "invalid")

      result.should be_nil
    end

    it "returns a User when the user's password is correct'" do
      hash = Crypto::Bcrypt::Password.create("test", cost: 4)
      repo = UserRepoMock.new(
        get_by_email_return: Laspatule::Models::UserWithPassword.new(
          id: 1,
          enabled: true,
          name: "user",
          email: "garbage",
          password: hash.to_s,
        )
      )
      service = Laspatule::Services::Users.new(repo)

      result = service.auth(email: "test", password: "test")

      result.class.should eq(Laspatule::Models::User)
      result = result.not_nil!
      result.id.should eq(1)
      result.name.should eq("user")
    end
  end
end
