require "base64"
require "crypto/bcrypt/password"
require "random/secure"

class Laspatule::Services::Users
  def initialize(@repository : Repositories::Users, @mail : Mail)
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
    id = @repository.create(user)

    token = create_token(64)
    @repository.set_renew_token(id, token)

    @mail.send(
      to: user.email,
      subject: "Compte créé sur Laspatule.club",
      text: "Ton compte vient d'être créé sur LaSpatule ! Clique ici pour l'activer : https://laspatule.club/user/activate/#{token}",
    )
  end

  # Creates a new access token for this *user* and returns it.
  def create_access_token(user : Models::User) : String
    access_token = create_token(128)
    @repository.add_access_token(user.id, access_token)
    access_token
  end

  private def create_token(size : Int32) : String
    bytes = Random::Secure.random_bytes(size)
    Base64.urlsafe_encode(bytes).rstrip('=')
  end
end
