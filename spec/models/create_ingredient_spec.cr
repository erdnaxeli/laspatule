require "./spec_helper"

describe Laspatule::Models::CreateIngredient do
  describe ".new" do
    it "creates a new CreateIngredient" do
      ingredient = Laspatule::Models::CreateIngredient.new(name: "aubergine")
      ingredient.name.should eq("aubergine")
    end
  end

  describe ".from_json" do
    it "returns a new CreateIngredient from json" do
      ingredient = Laspatule::Models::CreateIngredient.from_json(
        %({"name": "aubergine"})
      )
      ingredient.class.should eq(Laspatule::Models::CreateIngredient)
      ingredient.name.should eq("aubergine")
    end
  end

  describe "#check" do
    it "returns an empty hash when there is no error" do
      ingredient = Laspatule::Models::CreateIngredient.new(name: "aubergine")
      ingredient.validate.size.should eq(0)
    end

    it "returns an error when the name is too long" do
      ingredient = Laspatule::Models::CreateIngredient.new(name: "*" * 101)
      errors = ingredient.validate

      errors.size.should eq(1)
      errors["name"].size.should eq(1)
      errors["name"][0].should eq(Laspatule::Models::Validation::Error::TooLong)
    end

    it "returns an error when the name is too short" do
      ingredient = Laspatule::Models::CreateIngredient.new(name: "")
      errors = ingredient.validate

      errors.size.should eq(1)
      errors["name"].size.should eq(1)
      errors["name"][0].should eq(Laspatule::Models::Validation::Error::TooShort)
    end
  end
end
