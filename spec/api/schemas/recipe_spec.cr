require "./spec_helper"

describe "Laspatule::API::Schemas::Recipe" do
  describe ".new" do
    it "works" do
      recipe = Laspatule::Models::Recipe.new(
        id: 1,
        title: "Ratatouille",
        user: Laspatule::Models::User.new(
          id: 10,
          name: "user",
        ),
        ingredients: [
          Laspatule::Models::Recipe::Ingredient.new(
            id: 2,
            quantity: "1",
            ingredient: Laspatule::Models::Ingredient.new(
              id: 3,
              name: "aubergine",
            ),
          ),
          Laspatule::Models::Recipe::Ingredient.new(
            id: 4,
            quantity: "1",
            ingredient: Laspatule::Models::Ingredient.new(
              id: 5,
              name: "courgette",
            )
          ),
        ],
        sections: [
          Laspatule::Models::Recipe::Section.new(
            id: 6,
            title: "l'aubergine",
            steps: [
              Laspatule::Models::Recipe::Step.new(
                id: 7,
                instruction: "couper l'aubergine en cubes"
              ),
              Laspatule::Models::Recipe::Step.new(
                id: 8,
                instruction: "faire revenir rapidement à la poêle"
              ),
              Laspatule::Models::Recipe::Step.new(
                id: 9,
                instruction: "ajouter le tout à la marmite"
              ),
            ]
          ),
        ]
      )

      recipe_schema = Laspatule::API::Schemas::Recipe.new(recipe)

      recipe_schema.id.should eq(recipe.id)
      recipe_schema.title.should eq(recipe.title)
      recipe_schema.sections.should eq(recipe.sections)
      recipe_schema.ingredients.size.should eq(2)
      recipe_schema.ingredients[0].id.should eq(3)
      recipe_schema.ingredients[0].name.should eq("aubergine")
      recipe_schema.ingredients[0].quantity.should eq("1")
      recipe_schema.ingredients[1].id.should eq(5)
      recipe_schema.ingredients[1].name.should eq("courgette")
      recipe_schema.ingredients[1].quantity.should eq("1")
    end
  end
end
