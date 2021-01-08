class Laspatule::Services::Ingredients
  def initialize(@user_id : Int32, @repository : Repositories::Ingredients)
  end

  # Creates a new ingredient and returns its id.
  def create(ingredient : Models::CreateIngredient) : Int32
    @repository.create(ingredient)
  end

  # Gets an ingredient by id.
  def get_by_id(id : Int32) : Models::Ingredient
    @repository.get_by_id(id)
  end
end
