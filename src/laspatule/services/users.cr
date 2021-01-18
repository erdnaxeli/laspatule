require "base64"
require "crypto/bcrypt/password"
require "random/secure"

class Laspatule::Services::Users
  def initialize(@repository : Repositories::Users)
  end

  # Authenticates a user and returns its.
  #
  # If the authentication fails, return nil.
  def auth(email : String, password : String) : Models::User?
    user = @repository.get_by_email(email)
    if user.enabled && (user_password = user.password)
      password_hash = Crypto::Bcrypt::Password.new(user_password)

      if password_hash.verify(password)
        return Models::User.new(id: user.id, name: user.name)
      end
    end

    nil
  rescue Repositories::Users::UserNotFoundError
    nil
  end

  # Create a new user.
  #
  # Create the user, then send their an email to activate its account.
  def create(user : Models::CreateUser) : Nil
    @repository.create(user)
  end
end
