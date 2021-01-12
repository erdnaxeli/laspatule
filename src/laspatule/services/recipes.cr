class Laspatule::Services::Recipes
  def initialize(@user_id : Int32, @repository : Repositories::Recipes)
  end

  # Creates a new recipe and returns its id.
  def create(recipe : Models::CreateRecipe) : Models::Recipe
    id = @repository.create(recipe, @user_id)
    @repository.get_by_id(id)
  end

  # Gets all recipes ordered by name.
  def get_all(page_size : Int32, next_page previous_page : Int32? = nil) : Models::Page(Models::Recipe)
    @repository.get_all(page_size, previous_page)
  end

  # Gets a recipe by id.
  def get_by_id(id : Int32) : Models::Recipe
    @repository.get_by_id(id)
  end
end
