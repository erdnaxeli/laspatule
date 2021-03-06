require "../models"

module Laspatule::Repositories::Recipes
  class DuplicatedRecipeError < DuplicatedError
  end

  class RecipeNotFoundError < NotFoundError
  end

  # Creates a new recipe and returns its id.
  abstract def create(recipe : Models::CreateRecipe, user_id : Int32) : Int32
  # Gets a recipe by id.
  abstract def get_by_id(id : Int32) : Models::Recipe
  # Gets all recipes ordered by name,
  #
  # This is a paginated query, see `Models::Page` for the pagination instructions.
  abstract def get_all(page_size : Int32, next_page previous_page : String? = nil) : Models::Page(Models::Recipe)
end
