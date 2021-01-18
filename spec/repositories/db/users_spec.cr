require "./spec_helper"

describe Laspatule::Repositories::DB::Users do
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

  describe "#get_by_id" do
    with_users_repo do |repo|
      it "raises an error when the user is not found" do
        expect_raises(Laspatule::Repositories::Users::UserNotFoundError) do
          repo.get_by_id(12)
        end
      end

      it "returns a user with the correct id" do
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
end
