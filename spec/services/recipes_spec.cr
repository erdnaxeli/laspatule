require "./spec_helper"

describe Laspatule::Services::Recipes do
  describe "#create" do
    it "creates a new recipe and returns it" do
      mock = RecipesRepoMock.new(
        create_return: 42,
        get_by_id_return: Laspatule::Models::Recipe.new(
          id: 42,
          title: "Ratatouille",
          user: Laspatule::Models::User.new(id: 1, name: "user"),
        ),
      )
      service = Laspatule::Services::Recipes.new(12, mock)

      result = service.create(
        Laspatule::Models::CreateRecipe.new(
          title: "Ratatouille",
          ingredients: Array(Laspatule::Models::CreateRecipe::CreateIngredient).new,
          sections: Array(Laspatule::Models::CreateRecipe::CreateSection).new,
        )
      )

      result.class.should eq(Laspatule::Models::Recipe)
      result.id.should eq(42)
      result.title.should eq("Ratatouille")
    end
  end

  describe "#get_all" do
    it "returns a page" do
      mock = RecipesRepoMock.new(
        get_all_return: Laspatule::Models::Page(Laspatule::Models::Recipe).new(
          content: Array(Laspatule::Models::Recipe).new,
          next_page: nil,
        )
      )
      service = Laspatule::Services::Recipes.new(12, mock)

      result = service.get_all(20)

      result.class.should eq(Laspatule::Models::Page(Laspatule::Models::Recipe))
    end
  end

  describe "#get_by_id" do
    it "returns a recipe" do
      mock = RecipesRepoMock.new(
        get_by_id_return: Laspatule::Models::Recipe.new(
          id: 42,
          title: "Ratatouille",
          user: Laspatule::Models::User.new(id: 1, name: "user"),
        ),
      )
      service = Laspatule::Services::Recipes.new(12, mock)

      result = service.get_by_id(42)

      result.class.should eq(Laspatule::Models::Recipe)
      result.id.should eq(42)
      result.title.should eq("Ratatouille")
    end
  end
end
