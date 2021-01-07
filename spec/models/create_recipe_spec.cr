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

  describe "#validate" do
    it "returns no error when there is not" do
      recipe = Laspatule::Models::CreateRecipe.new(
        title: "Ratatouille",
        ingredients: Array(Int32).new,
        sections: Array(Laspatule::Models::CreateRecipe::CreateSection).new,
      )
      recipe.validate.size.should eq(0)
    end

    it "returns an error when the title is too short" do
      recipe = Laspatule::Models::CreateRecipe.new(
        title: "",
        ingredients: Array(Int32).new,
        sections: Array(Laspatule::Models::CreateRecipe::CreateSection).new,
      )
      errors = recipe.validate

      errors.size.should eq(1)
      errors["title"].size.should eq(1)
      errors["title"][0].should eq(Laspatule::Models::Validation::Error::TooShort)
    end

    it "returns an error when the title is too long" do
      recipe = Laspatule::Models::CreateRecipe.new(
        title: "*" * 101,
        ingredients: Array(Int32).new,
        sections: Array(Laspatule::Models::CreateRecipe::CreateSection).new,
      )
      errors = recipe.validate

      errors.size.should eq(1)
      errors["title"].size.should eq(1)
      errors["title"][0].should eq(Laspatule::Models::Validation::Error::TooLong)
    end

    it "returns an error correctly index when a section is incorrect" do
      invalid_section = Laspatule::Models::CreateRecipe::CreateSection.new(
        title: "",
        steps: Array(Laspatule::Models::CreateRecipe::CreateStep).new,
      )
      recipe = Laspatule::Models::CreateRecipe.new(
        title: "La ratatouille",
        ingredients: Array(Int32).new,
        sections: [
          Laspatule::Models::CreateRecipe::CreateSection.new(
            title: "L'aubergine",
            steps: Array(Laspatule::Models::CreateRecipe::CreateStep).new,
          ),
          invalid_section,
        ]
      )
      errors = recipe.validate

      errors.size.should eq(1)
      errors["sections"].size.should eq(1)
      errors["sections"][1].should eq(invalid_section.validate)
    end
  end
end
