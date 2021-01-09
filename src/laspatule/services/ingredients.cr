class Laspatule::Services::Ingredients
  def initialize(@user_id : Int32, @repository : Repositories::Ingredients)
  end

  # Creates a new ingredient and returns its.
  def create(ingredient : Models::CreateIngredient) : Models::Ingredient
    id = @repository.create(ingredient)
    @repository.get_by_id(id)
  end

  # Gets an ingredient by id.
  def get_by_id(id : Int32) : Models::Ingredient
    @repository.get_by_id(id)
  end

  # Search ingredients by name.
  #
  # See `Models::Page` documentation about pagination.
  def search_by_name(name : String, page_size : Int32, next_page : String?) : Models::Page(Models::Ingredient)
    @repository.search_by_name(name, page_size, next_page)
  end
end
