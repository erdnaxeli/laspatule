require "./spec_helper"

describe Laspatule::Models::Recipe::Ingredient do
  describe ".new" do
    it "creates a new RecipeIngredient" do
      r_ingredient = Laspatule::Models::Recipe::Ingredient.new(
        id: 42,
        quantity: "1",
        ingredient: AUBERGINE,
      )
      r_ingredient.id.should eq(42)
      r_ingredient.quantity.should eq("1")
      r_ingredient.ingredient.should eq(AUBERGINE)
    end
  end

  describe ".from_json" do
    it "returns a RecipeIngredient from json" do
      ingredient = Laspatule::Models::Recipe::Ingredient.from_json(%(
        {
          "id": 42,
          "quantity": "1",
          "ingredient": {
            "id": 42,
            "name": "aubergine"
          }
        }
      ))
      ingredient.class.should eq(Laspatule::Models::Recipe::Ingredient)
      ingredient.id.should eq(42)
      ingredient.quantity.should eq("1")
      ingredient.ingredient.should eq(AUBERGINE)
    end
  end

  describe "#to_json" do
    it "serializes a RecipeIngredient to json" do
      ingredient = Laspatule::Models::Recipe::Ingredient.new(id: 42, quantity: "1", ingredient: AUBERGINE)
      ingredient.to_json.should eq(%({"id":42,"quantity":"1","ingredient":{"id":42,"name":"aubergine"}}))
    end
  end
end
