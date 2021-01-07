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

  describe "#validate" do
    it "returns no error when there is not" do
      ingredient = Laspatule::Models::CreateRecipe::CreateRecipeIngredient.new(
        quantity: "1",
        ingredient: CREATE_AUBERGINE,
      )
      ingredient.validate.size.should eq(0)
    end

    it "returns an error when the quantity is too short" do
      ingredient = Laspatule::Models::CreateRecipe::CreateRecipeIngredient.new(
        quantity: "",
        ingredient: CREATE_AUBERGINE,
      )
      errors = ingredient.validate

      errors.size.should eq(1)
      errors["quantity"].size.should eq(1)
      errors["quantity"][0].should eq(Laspatule::Models::Validation::Error::TooShort)
    end

    it "returns an error when the quantity is too long" do
      ingredient = Laspatule::Models::CreateRecipe::CreateRecipeIngredient.new(
        quantity: "*" * 101,
        ingredient: CREATE_AUBERGINE,
      )
      errors = ingredient.validate

      errors.size.should eq(1)
      errors["quantity"].size.should eq(1)
      errors["quantity"][0].should eq(Laspatule::Models::Validation::Error::TooLong)
    end

    it "returns an error when the ingredient is incorrect" do
      invalid = Laspatule::Models::CreateIngredient.new(name: "")
      ingredient = Laspatule::Models::CreateRecipe::CreateRecipeIngredient.new(
        quantity: "1",
        ingredient: invalid,
      )
      errors = ingredient.validate

      errors.size.should eq(1)
      errors["ingredient"].size.should eq(1)
      errors["ingredient"].should eq(invalid.validate)
    end
  end
end
