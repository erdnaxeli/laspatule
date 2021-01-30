require "./spec_helper"

describe Laspatule::Services::Users do
  describe "#auth" do
    it "returns nil when the user is not found" do
      repo = UserRepoMock.new(
        get_by_email_return: Laspatule::Repositories::Users::UserNotFoundError.new
      )
      mail = MailServiceMock.new
      service = Laspatule::Services::Users.new(repo, mail)

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
      mail = MailServiceMock.new
      service = Laspatule::Services::Users.new(repo, mail)

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
      mail = MailServiceMock.new
      service = Laspatule::Services::Users.new(repo, mail)

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
      mail = MailServiceMock.new
      service = Laspatule::Services::Users.new(repo, mail)

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
      mail = MailServiceMock.new
      service = Laspatule::Services::Users.new(repo, mail)

      result = service.auth(email: "test", password: "test")

      result.class.should eq(Laspatule::Models::User)
      result = result.not_nil!
      result.id.should eq(1)
      result.name.should eq("user")
    end
  end

  describe "#create" do
    it "creates a new user, set their renew token, and send them a mail" do
      repo = UserRepoMock.new(create_return: 12)
      mail = MailServiceMock.new
      service = Laspatule::Services::Users.new(repo, mail)

      service.create(Laspatule::Models::CreateUser.new(
        name: "user",
        email: "user@email.org",
      ))

      repo.set_renew_token_calls.size.should eq(1)
      repo.set_renew_token_calls[0]["user_id"].should eq(12)
      mail.send_calls.size.should eq(1)
      mail.send_calls[0]["to"].should eq("user@email.org")
      mail.send_calls[0]["subject"].should eq("Compte créé sur Laspatule.club")
    end
  end

  describe "#create_access_token" do
    it "creates a new access_token for the given user" do
      repo = UserRepoMock.new
      mail = MailServiceMock.new
      service = Laspatule::Services::Users.new(repo, mail)

      access_token = service.create_access_token(Laspatule::Models::User.new(
        id: 12,
        name: "user",
      ))

      repo.add_access_token_calls.size.should eq(1)
      repo.add_access_token_calls[0]["user_id"].should eq(12)
      repo.add_access_token_calls[0]["access_token"].should eq(access_token)
    end
  end

  describe "#get_by_access_token?" do
    it "returns a user if found" do
      user = Laspatule::Models::User.new(
        id: 12,
        name: "douze",
      )
      repo = UserRepoMock.new(get_by_access_token: user)
      mail = MailServiceMock.new
      service = Laspatule::Services::Users.new(repo, mail)

      result = service.get_by_access_token?("access_token")

      result.should eq(user)
    end

    it "returns nil when the user is not found" do
      repo = UserRepoMock.new(
        get_by_access_token: Laspatule::Repositories::Users::UserNotFoundError.new
      )
      mail = MailServiceMock.new
      service = Laspatule::Services::Users.new(repo, mail)

      result = service.get_by_access_token?("access_token")

      result.should be_nil
    end
  end
end
