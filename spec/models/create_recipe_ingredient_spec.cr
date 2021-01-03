require "./spec_helper"

describe Laspatule::Models::CreateRecipe::CreateRecipeIngredient do
  describe ".new" do
    it "creates a new CreateRecipeIngredient" do
      ingredient = Laspatule::Models::CreateRecipe::CreateRecipeIngredient.new(
        quantity: "1",
        ingredient: CREATE_AUBERGINE,
      )
      ingredient.quantity.should eq("1")
      ingredient.ingredient.should eq(CREATE_AUBERGINE)
    end
  end

  describe ".from_json" do
    it "returns a new CreateRecipeIngredient from json" do
      ingredient = Laspatule::Models::CreateRecipe::CreateRecipeIngredient.from_json(
        %(
          {
            "quantity": "1",
            "ingredient": {"name": "aubergine"}
          }
        )
      )
      ingredient.class.should eq(Laspatule::Models::CreateRecipe::CreateRecipeIngredient)
      ingredient.quantity.should eq("1")
      ingredient.ingredient.should eq(CREATE_AUBERGINE)
    end
  end
end
