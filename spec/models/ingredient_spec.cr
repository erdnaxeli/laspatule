require "./spec_helper"

describe Laspatule::Models::Ingredient do
  describe ".new" do
    it "accepts an id and a name" do
      ingredient = Laspatule::Models::Ingredient.new(id: 42, name: "aubergine")
      ingredient.id.should eq(42)
      ingredient.name.should eq("aubergine")
    end
  end

  describe ".from_json" do
    it "returns an ingredient object from json" do
      ingredient = Laspatule::Models::Ingredient.from_json(%({"id":42,"name":"aubergine"}))
      ingredient.class.should eq(Laspatule::Models::Ingredient)
      ingredient.id.should eq(42)
      ingredient.name.should eq("aubergine")
    end
  end

  describe "#to_json" do
    it "serializes an ingredient to json" do
      ingredient = Laspatule::Models::Ingredient.new(id: 42, name: "aubergine")
      ingredient.to_json.should eq(%({"id":42,"name":"aubergine"}))
    end
  end
end
