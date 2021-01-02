require "./spec_helper"

describe Laspatule::Models::Ingredient do
  it "accepts an id and a name" do
    ingredient = Laspatule::Models::Ingredient.new(id: 42, name: "aubergine")
    ingredient.id.should eq(42)
    ingredient.name.should eq("aubergine")
  end

  # it "can be serialized to json" do
  #   ingredient = Laspatule::Models::Ingredient.new(id: 42, name: "aubergine")
  #   ingredient.to_json.should eq(%({"id":42,"name":"aubergine"}))
  # end

  # it "can be deserialized from json" do
  #   ingredient = Laspatule::Models::Ingredient.from_json(%({"id":42,"name":"aubergine"}))
  #   ingredient.id.should eq(42)
  #   ingredient.name.should eq("aubergine")
  # end
end
