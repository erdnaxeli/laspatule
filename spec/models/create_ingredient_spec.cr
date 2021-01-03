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
end
