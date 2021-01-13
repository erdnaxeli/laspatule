require "./spec_helper"

describe Laspatule::Models::CreateRecipe do
  describe ".new" do
    it "creates a new CreateRecipe" do
      recipe = Laspatule::Models::CreateRecipe.new(
        title: "Ratatouille",
        ingredients: Array(Laspatule::Models::CreateRecipe::CreateIngredient).new,
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
        ingredients: [CREATE_RECIPE_AUBERGINE],
        sections: [CREATE_SECTION],
      )
      recipe.validate.size.should eq(0)
    end

    it "returns an error when the title is too short" do
      recipe = Laspatule::Models::CreateRecipe.new(
        title: "",
        ingredients: [CREATE_RECIPE_AUBERGINE],
        sections: [CREATE_SECTION],
      )
      errors = recipe.validate

      errors.size.should eq(1)
      errors["title"].size.should eq(1)
      errors["title"][0].should eq(Laspatule::Models::Validation::Error::TooShort)
    end

    it "returns an error when the title is too long" do
      recipe = Laspatule::Models::CreateRecipe.new(
        title: "*" * 101,
        ingredients: [CREATE_RECIPE_AUBERGINE],
        sections: [CREATE_SECTION],
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
        ingredients: [CREATE_RECIPE_AUBERGINE],
        sections: [
          CREATE_SECTION,
          invalid_section,
        ]
      )
      errors = recipe.validate

      errors.size.should eq(1)
      errors["sections"].size.should eq(1)
      errors["sections"][1].should eq(invalid_section.validate)
    end

    it "returns an error when there are duplicated ingredients" do
      recipe = Laspatule::Models::CreateRecipe.new(
        title: "La ratatouille",
        ingredients: [
          Laspatule::Models::CreateRecipe::CreateIngredient.new(
            quantity: "1",
            ingredient_id: 1,
          ),
          Laspatule::Models::CreateRecipe::CreateIngredient.new(
            quantity: "2",
            ingredient_id: 1
          ),
        ],
        sections: [CREATE_SECTION]
      )
      errors = recipe.validate

      errors.size.should eq(1)
      errors["ingredients"].size.should eq(1)
      errors["ingredients"][1].should eq([Laspatule::Models::Validation::Error::DuplicatedElement])
    end

    it "returns all errors for ingredients" do
      invalid_quantity = Laspatule::Models::CreateRecipe::CreateIngredient.new(
        quantity: "",
        ingredient_id: 1,
      )
      recipe = Laspatule::Models::CreateRecipe.new(
        title: "La ratatouille",
        ingredients: [
          invalid_quantity,
          Laspatule::Models::CreateRecipe::CreateIngredient.new(
            quantity: "2",
            ingredient_id: 1
          ),
        ],
        sections: [CREATE_SECTION]
      )
      errors = recipe.validate

      errors.size.should eq(1)
      errors["ingredients"].size.should eq(2)
      errors["ingredients"][0].should eq(invalid_quantity.validate)
      errors["ingredients"][1].should eq([Laspatule::Models::Validation::Error::DuplicatedElement])
    end

    it "returns an error when there is no ingredients" do
      recipe = Laspatule::Models::CreateRecipe.new(
        title: "Ratatouille",
        ingredients: Array(Laspatule::Models::CreateRecipe::CreateIngredient).new,
        sections: [CREATE_SECTION],
      )
      errors = recipe.validate

      errors.size.should eq(1)
      errors["ingredients"].size.should eq(1)
      errors["ingredients"][0].should eq(Laspatule::Models::Validation::Error::TooShort)
    end

    it "returns an error when there is no sections" do
      recipe = Laspatule::Models::CreateRecipe.new(
        title: "Ratatouille",
        ingredients: [CREATE_RECIPE_AUBERGINE],
        sections: Array(Laspatule::Models::CreateRecipe::CreateSection).new,
      )
      errors = recipe.validate

      errors.size.should eq(1)
      errors["sections"].size.should eq(1)
      errors["sections"][0].should eq(Laspatule::Models::Validation::Error::TooShort)
    end
  end
end
