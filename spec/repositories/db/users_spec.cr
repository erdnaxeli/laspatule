require "./spec_helper"

describe Laspatule::Repositories::DB::Users do
  describe "#add_access_token" do
    with_users_repo do |repo, db|
      it "saves an access token" do
        user = Laspatule::Models::CreateUser.new(
          name: "user", email: "email",
        )
        id = repo.create(user)

        repo.add_access_token(id, "token")

        result = db.query_all(
          "SELECT user_id, access_token FROM user_session",
          as: {user_id: Int64, access_token: String},
        )
        result.size.should eq(1)
        result[0]["user_id"].should eq(id)
        result[0]["access_token"].should eq("token")
      end
    end
  end

  describe "#create" do
    with_users_repo do |repo, db|
      it "creates a new User" do
        user = Laspatule::Models::CreateUser.new(
          name: "user", email: "email",
        )

        id = repo.create(user)

        result = db.query_all(
          "SELECT id, enabled, name, email, password FROM user",
          as: {id: Int64, enabled: Bool, name: String, email: String, password: String?},
        )
        result.size.should eq(1)
        result[0]["id"].to_i.should eq(id)
        result[0]["enabled"].should be_false
        result[0]["name"].should eq("user")
        result[0]["email"].should eq("email")
        result[0]["password"].should be_nil
      end
    end
  end

  describe "#get_by_email" do
    with_users_repo do |repo|
      it "raises an error when the user is not found" do
        expect_raises(Laspatule::Repositories::Users::UserNotFoundError) do
          repo.get_by_email("nop")
        end
      end

      it "returns a user with the correct email" do
        user1 = Laspatule::Models::CreateUser.new(
          name: "user1", email: "email1",
        )
        user2 = Laspatule::Models::CreateUser.new(
          name: "user2", email: "email2",
        )
        id1 = repo.create(user1)
        repo.create(user2)

        user = repo.get_by_email(user1.email)

        user.id.should eq(id1)
        user.name.should eq(user1.name)
        user.email.should eq(user1.email)
      end
    end
  end

  describe "#get_by_access_token" do
    with_users_repo do |repo|
      it "raises an error when the user is not found" do
        expect_raises(Laspatule::Repositories::Users::UserNotFoundError) do
          repo.get_by_access_token("nop")
        end
      end

      it "returns the correct user" do
        user1 = Laspatule::Models::CreateUser.new(
          name: "user1", email: "email1",
        )
        user2 = Laspatule::Models::CreateUser.new(
          name: "user2", email: "email2",
        )
        id1 = repo.create(user1)
        id2 = repo.create(user2)
        repo.add_access_token(id1, "access_token1")
        repo.add_access_token(id2, "access_token2")

        user = repo.get_by_access_token("access_token1")

        user.id.should eq(id1)
        user.name.should eq("user1")
      end
    end
  end

  describe "#get_by_email" do
    with_users_repo do |repo|
      it "raises an error when the user is not found" do
        expect_raises(Laspatule::Repositories::Users::UserNotFoundError) do
          repo.get_by_email("nop")
        end
      end

      it "returns the correct user" do
        user1 = Laspatule::Models::CreateUser.new(
          name: "user1", email: "email1",
        )
        user2 = Laspatule::Models::CreateUser.new(
          name: "user2", email: "email2",
        )
        id1 = repo.create(user1)
        repo.create(user2)

        user = repo.get_by_email("email1")

        user.id.should eq(id1)
        user.name.should eq("user1")
      end
    end
  end

  describe "#get_by_id" do
    with_users_repo do |repo|
      it "raises an error when the user is not found" do
        expect_raises(Laspatule::Repositories::Users::UserNotFoundError) do
          repo.get_by_id(12)
        end
      end

      it "returns the correct user" do
        user1 = Laspatule::Models::CreateUser.new(
          name: "user1", email: "email1",
        )
        user2 = Laspatule::Models::CreateUser.new(
          name: "user2", email: "email2",
        )
        id1 = repo.create(user1)
        repo.create(user2)

        user = repo.get_by_id(id1)

        user.id.should eq(id1)
        user.name.should eq(user1.name)
      end
    end
  end

  describe "#get_by_renew_token" do
    with_users_repo do |repo|
      it "raises an error when the user is not found" do
        expect_raises(Laspatule::Repositories::Users::UserNotFoundError) do
          repo.get_by_renew_token("nop")
        end
      end

      it "returns the correct user" do
        user1 = Laspatule::Models::CreateUser.new(
          name: "user1", email: "email1",
        )
        user2 = Laspatule::Models::CreateUser.new(
          name: "user2", email: "email2",
        )
        id1 = repo.create(user1)
        id2 = repo.create(user2)
        repo.set_renew_token(id1, "renew_token1")
        repo.set_renew_token(id2, "renew_token2")

        user = repo.get_by_renew_token("renew_token1")

        user.id.should eq(id1)
        user.name.should eq(user1.name)
      end
    end
  end

  describe "#set_renew_token" do
    with_users_repo do |repo, db|
      it "sets the renew_token for the given user" do
        user = Laspatule::Models::CreateUser.new(
          name: "user", email: "email",
        )
        id = repo.create(user)

        repo.set_renew_token(id, "renew_token")

        result = db.query_all(
          "SELECT user_id, token FROM password_reinit",
          as: {user_id: Int64, token: String},
        )
        result.size.should eq(1)
        result[0]["user_id"].should eq(id)
        result[0]["token"].should eq("renew_token")
      end
    end
  end
end
