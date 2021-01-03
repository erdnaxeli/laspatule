require "../models"

module Laspatule::Repositories::Recipes
  # Gets a recipe by id.
  abstract def get_by_id(id : Int32) : Models::Recipe
  # Gets all recipes, ordered by name,
  #
  # This is a paginated query, see `Page` for the pagination instructions.
  abstract def get_all(page_size : Int32, next_page previous_page : Int32) : Page(Recipe)
  # Stores a new recipe and returns its id.
  abstract def store(recipe : Models::Recipe) : Int32
end
