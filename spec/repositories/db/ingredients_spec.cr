require "./spec_helper"

describe Laspatule::Repositories::DB::Ingredients do
  describe "#create" do
    it "creates a new ingredient and returns its id" do
      with_ingredient_repo do |repo, db|
        ingredient = Laspatule::Models::CreateIngredient.new(name: "aubergine")
        id = repo.create(ingredient)

        result = db.query_one(
          "SELECT id, name FROM ingredient WHERE name = ?",
          "aubergine",
          as: {Int64, String}
        )
        result[0].to_i.should eq(id)
        result[1].should eq("aubergine")
      end
    end

    it "raises an error when creating a duplicated ingredient" do
      with_ingredient_repo do |repo|
        ingredient = Laspatule::Models::CreateIngredient.new(name: "aubergine")
        repo.create(ingredient)

        expect_raises(Laspatule::Repositories::Ingredients::DuplicatedIngredientError) do
          repo.create(ingredient)
        end
      end
    end
  end

  describe "#get_by_id" do
    it "gets an ingredient by id" do
      with_ingredient_repo do |repo|
        ingredient = Laspatule::Models::CreateIngredient.new(name: "aubergine")
        id = repo.create(ingredient)

        ingredient = repo.get_by_id(id)
        ingredient.class.should eq(Laspatule::Models::Ingredient)
        ingredient.id.should eq(id)
        ingredient.name.should eq("aubergine")
      end
    end

    it "raises an error when the ingredient is not found" do
      with_ingredient_repo do |repo|
        expect_raises(Laspatule::Repositories::Ingredients::IngredientNotFoundError) do
          repo.get_by_id(42)
        end
      end
    end
  end
end
