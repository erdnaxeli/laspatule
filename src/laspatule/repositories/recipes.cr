require "../models"

module Laspatule::Repositories::Recipes
  # Creates a new recipe and returns its id.
  abstract def creates(recipe : Models::CreateRecipe, user_id : Int32) : Int32
  # Gets a recipe by id.
  abstract def get_by_id(id : Int32) : Models::Recipe
  # Gets all recipes, ordered by name,
  #
  # This is a paginated query, see `Models::Page` for the pagination instructions.
  abstract def get_all(page_size : Int32, next_page previous_page : Int32) : Models::Page(Recipe)
end
