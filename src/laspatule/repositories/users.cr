require "../models"

module Laspatule::Repositories::Users
  class UserNotFoundError < NotFoundError
  end

  # Adds a new access token for the user *user_id*.
  abstract def add_access_token(user_id : Int32, access_token : String) : Nil

  # Creates a new user
  abstract def create(user : Models::CreateUser) : Int32

  # Gets a user by its access token.
  #
  # It raises an error `UserNotFoundError` if teh user is not found.
  abstract def get_by_access_token(access_token : String) : Models::User

  # Gets a user by its email.
  #
  # It raises an error `UserNotFoundError` if the user is not found.
  abstract def get_by_email(email : String) : Models::UserWithPassword

  # Gets a user by its id.
  #
  # It raises an error `UserNotFoundError` if the user is not found.
  abstract def get_by_id(id : Int32) : Models::User

  # Gets a user by its renew token.
  #
  # It raises an error `UserNotFoundError` if the user is not found.
  abstract def get_by_renew_token(renew_token : String) : Models::User

  # Sets the renew token for the user *user_id*.
  abstract def set_renew_token(user_id : Int32, token : String) : Nil
end
