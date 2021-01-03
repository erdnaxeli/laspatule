require "./spec_helper"

describe Laspatule::Models::CreateRecipe do
  describe ".new" do
    it "creates a new CreateRecipe" do
      recipe = Laspatule::Models::CreateRecipe.new(
        title: "Ratatouille",
        ingredients: Array(Int32).new,
        sections: Array(Laspatule::Models::CreateRecipe::CreateSection).new,
      )
      recipe.title.should eq("Ratatouille")
      recipe.ingredients.size.should eq(0)
      recipe.sections.size.should eq(0)
    end
  end

  describe ".from_json" do
    it "returns a new CreateRecipe from json" do
      recipe = Laspatule::Models::CreateRecipe.from_json(
        %(
          {
            "title": "Ratatouille",
            "ingredients": [],
            "sections": []
          }
        )
      )
      recipe.class.should eq(Laspatule::Models::CreateRecipe)
      recipe.title.should eq("Ratatouille")
      recipe.ingredients.size.should eq(0)
      recipe.sections.size.should eq(0)
    end
  end
end
