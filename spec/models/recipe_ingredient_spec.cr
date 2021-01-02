require "./spec_helper"

describe Laspatule::Models::Recipe::Ingredient do
  it "can be created" do
    r_ingredient = Laspatule::Models::Recipe::Ingredient.new(
      id: 42,
      quantity: "1",
      ingredient: AUBERGINE,
    )
    r_ingredient.id.should eq(42)
    r_ingredient.quantity.should eq("1")
    r_ingredient.ingredient.should eq(AUBERGINE)
  end

  # it "can be serialized to json" do
  #   ingredient = Laspatule::Models::RecipeIngredient.new(id: 42, quantity: "1", ingredient_id: 10)
  #   ingredient.to_json.should eq(%({"id":42,"quantity":"1","ingredient_id":10}))
  # end

  # it "can be deserialized from json" do
  #   ingredient = Laspatule::Models::RecipeIngredient.from_json(%({"id": 42, "quantity": "1", "ingredient_id": 10}))
  #   ingredient.id.should eq(42)
  #   ingredient.quantity.should eq("1")
  #   ingredient.ingredient_id.should eq(10)
  # end
end
