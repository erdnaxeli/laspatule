require "../models"

module Laspatule::Repositories::Users
  class UserNotFoundError < NotFoundError
  end

  # Creates a new user
  abstract def create(user : Models::CreateUser) : Int32

  # Gets a user by its email.
  #
  # It raises an error `UserNotFoundError` if the user is not fond.
  abstract def get_by_email(email : String) : Models::UserWithPassword

  # Gets a user by its id.
  #
  # It raises an error `UserNotFoundError` if the user is not found.
  abstract def get_by_id(id : Int32) : Models::User
end
