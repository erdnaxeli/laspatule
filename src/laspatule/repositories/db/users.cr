require "db"

require "../users"

class Laspatule::Repositories::DB::Users
  include Repositories::Users

  def initialize(@db : ::DB::Database)
  end

  def create(user : Models::CreateUser) : Int32
    er = @db.exec(
      "INSERT INTO user (name, email) VALUES (?, ?)",
      user.name,
      user.email,
    )
    er.last_insert_id.to_i
  end

  def get_by_email(email : String) : Models::UserWithPassword
    result = @db.query_one?(
      "
        SELECT
          id
          , enabled
          , name
          , password
        FROM user
        WHERE email = ?
      ",
      email,
      as: {id: Int64, enabled: Bool, name: String, password: String?},
    )
    raise UserNotFoundError.new if result.nil?

    Models::UserWithPassword.new(
      id: result["id"].to_i,
      enabled: result["enabled"],
      name: result["name"],
      email: email,
      password: result["password"],
    )
  end

  def get_by_id(id : Int32) : Models::User
    result = @db.query_one?(
      "SELECT enabled, name FROM user WHERE id = ?",
      id,
      as: {enabled: Bool, name: String},
    )
    raise UserNotFoundError.new if result.nil?

    Models::User.new(
      id: id,
      name: result["name"],
    )
  end
end
