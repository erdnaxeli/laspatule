require "../models"
require "./exceptions"

module Laspatule::Repositories::Ingredients
  class DuplicatedIngredientError < DuplicatedError
  end

  class IngredientNotFoundError < NotFoundError
  end

  # Creates a new ingredient and returns its id.
  #
  # If an ingredient with the same name already exists, raises a
  # `DuplicatedIngredientError`.
  abstract def create(ingredient : Models::CreateIngredient) : Int32
  # Gets an ingredient by id.
  #
  # If the ingredient is not found, raises an `IngredientNotFoundError`.
  abstract def get_by_id(id : Int32) : Models::Ingredient
  # Gets an ingredient by name.
  #
  # Any ingredient containing the given name will be returned.
  # The ingredients are ordered by the size of the *name* string,
  # shortest first.
  #
  # This is a paginated query, see `Models::Page` for pagination instructions.
  abstract def search_by_name(name : String, page_size : Int32, next_page previous_page : Int32? = nil) : Models::Page(Ingredient)
end
