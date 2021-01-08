class Laspatule::Services::Recipes
  def initialize(@user_id, @repository : Repositories::Recipe)
  end

  # Creates a new recipe and returns its id.
  def create(recipe : Models::CreateRecipe) : Int32
    @repository.creates(recipe, @user_id)
  end

  # Gets a recipe by id.
  def get_by_id(id : Int32) : Models::Recipe
    @repository.get_by_id(id)
  end
end
