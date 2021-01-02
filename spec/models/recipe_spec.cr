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
end
