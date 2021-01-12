require "./spec_helper"

describe Laspatule::Models::CreateRecipe::CreateIngredient do
  describe ".new" do
    it "creates a new CreateIngredient" do
      ingredient = Laspatule::Models::CreateRecipe::CreateIngredient.new(
        quantity: "1",
        ingredient_id: 1,
      )
      ingredient.quantity.should eq("1")
      ingredient.ingredient_id.should eq(1)
    end
  end

  describe ".from_json" do
    it "returns a new CreateIngredient from json" do
      ingredient = Laspatule::Models::CreateRecipe::CreateIngredient.from_json(
        %(
          {
            "quantity": "1",
            "ingredient_id": 1
          }
        )
      )
      ingredient.class.should eq(Laspatule::Models::CreateRecipe::CreateIngredient)
      ingredient.quantity.should eq("1")
      ingredient.ingredient_id.should eq(1)
    end
  end

  describe "#validate" do
    it "returns no error when there is not" do
      ingredient = Laspatule::Models::CreateRecipe::CreateIngredient.new(
        quantity: "1",
        ingredient_id: 1,
      )
      ingredient.validate.size.should eq(0)
    end

    it "returns an error when the quantity is too short" do
      ingredient = Laspatule::Models::CreateRecipe::CreateIngredient.new(
        quantity: "",
        ingredient_id: 1,
      )
      errors = ingredient.validate

      errors.size.should eq(1)
      errors["quantity"].size.should eq(1)
      errors["quantity"][0].should eq(Laspatule::Models::Validation::Error::TooShort)
    end

    it "returns an error when the quantity is too long" do
      ingredient = Laspatule::Models::CreateRecipe::CreateIngredient.new(
        quantity: "*" * 101,
        ingredient_id: 1,
      )
      errors = ingredient.validate

      errors.size.should eq(1)
      errors["quantity"].size.should eq(1)
      errors["quantity"][0].should eq(Laspatule::Models::Validation::Error::TooLong)
    end
  end
end
