require "./spec_helper"

describe Laspatule::Models::Recipe do
  describe ".new" do
    it "add default ingredients and sections" do
      recipe = Laspatule::Models::Recipe.new(id: 42, title: "Ratatouille")
      recipe.id.should eq(42)
      recipe.title.should eq("Ratatouille")
      recipe.ingredients.size.should eq(0)
      recipe.sections.size.should eq(0)
    end
  end

  describe ".from_json" do
    it "returns a Recipe from json" do
      recipe = Laspatule::Models::Recipe.from_json(%(
        {
          "id": 42,
          "title": "Ratatouille",
          "ingredients": [],
          "sections": []
        }
      ))
      recipe.class.should eq(Laspatule::Models::Recipe)
      recipe.id.should eq(42)
      recipe.title.should eq("Ratatouille")
    end
  end

  describe "#to_json" do
    it "serializes a Recipe to json" do
      json = Laspatule::Models::Recipe.new(id: 42, title: "Ratatouille").to_json
      json.should eq(%({"id":42,"title":"Ratatouille","ingredients":[],"sections":[]}))
    end
  end
end
