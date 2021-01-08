require "../spec_helper"

class IngredientRepoMock
  include Laspatule::Repositories::Ingredients

  alias Calls = Hash(String, Array(Hash(String, Int32 | Laspatule::Models::CreateIngredient)))

  @calls = Calls.new do |h, k|
    h[k] = Array(Hash(String, Int32 | Laspatule::Models::CreateIngredient)).new
  end

  def calls
    @calls
  end

  def create(ingredient : Laspatule::Models::CreateIngredient) : Int32
    @calls["create"] << {"ingredient" => ingredient} of String => Int32 | Laspatule::Models::CreateIngredient
    1
  end

  def get_by_id(id : Int32) : Laspatule::Models::Ingredient
    @calls["get_by_id"] << {"id" => id} of String => Int32 | Laspatule::Models::CreateIngredient
    Laspatule::Models::Ingredient.new(
      id: 1,
      name: "aubergine",
    )
  end

  def reset : Nil
    @calls = Calls.new do |h, k|
      h[k] = Array(Hash(String, Int32 | Laspatule::Models::CreateIngredient)).new
    end
  end
end
