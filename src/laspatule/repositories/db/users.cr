require "db"

require "../users"

class Laspatule::Repositories::DB::Users
  include Repositories::Users

  def initialize(@db : ::DB::Database)
  end

  def add_access_token(user_id : Int32, access_token : String) : Nil
    @db.using_connection do |cnn|
      cnn.exec("PRAGMA foreign_keys = ON")
      cnn.exec(
        "INSERT INTO user_session (user_id, access_token) VALUES (?, ?)",
        user_id,
        access_token,
      )
    end
  end

  def create(user : Models::CreateUser) : Int32
    er = @db.exec(
      "INSERT INTO user (name, email) VALUES (?, ?)",
      user.name,
      user.email,
    )
    er.last_insert_id.to_i
  end

  def get_by_access_token(access_token : String) : Models::User
    result = @db.query_one?(
      "
        SELECT user.id, user.name
        FROM user
        JOIN user_session us
          ON user.id = us.user_id
        WHERE
          us.access_token = ?
      ",
      access_token,
      as: {id: Int64, name: String},
    )
    raise UserNotFoundError.new if result.nil?

    Models::User.new(
      id: result["id"].to_i,
      name: result["name"],
    )
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
    name = @db.query_one?(
      "SELECT name FROM user WHERE id = ?",
      id,
      as: String,
    )
    raise UserNotFoundError.new if name.nil?

    Models::User.new(
      id: id,
      name: name,
    )
  end

  def get_by_renew_token(renew_token : String) : Models::User
    result = @db.query_one?(
      "
        SELECT user.id, user.name
        FROM user
        JOIN password_reinit pr
          ON user.id = pr.user_id
        WHERE
          pr.token = ?
      ",
      renew_token,
      as: {id: Int64, name: String},
    )
    raise UserNotFoundError.new if result.nil?

    Models::User.new(
      id: result["id"].to_i,
      name: result["name"],
    )
  end

  def set_renew_token(user_id : Int32, token : String) : Nil
    @db.using_connection do |cnn|
      cnn.exec("PRAGMA foreign_keys = ON")
      cnn.exec(
        "INSERT INTO password_reinit (token, user_id) VALUES (?, ?)",
        token,
        user_id,
      )
    end
  end
end
