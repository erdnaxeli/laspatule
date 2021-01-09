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

    it "raises an error when the ingredient's name is too big" do
      with_ingredient_repo do |repo|
        ingredient = Laspatule::Models::CreateIngredient.new(name: "*" * 100)
        expect_raises(SQLite3::Exception) do
          repo.create(ingredient)
        end
      end
    end

    it "raises an error when the ingredient's name is empty" do
      with_ingredient_repo do |repo|
        ingredient = Laspatule::Models::CreateIngredient.new(name: "")
        expect_raises(Exception) do
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

  describe "#search_by_name" do
    with_ingredient_repo do |repo|
      repo.create(Laspatule::Models::CreateIngredient.new(name: "poivron"))
      repo.create(Laspatule::Models::CreateIngredient.new(name: "aubergine"))
      repo.create(Laspatule::Models::CreateIngredient.new(name: "oignon"))
      repo.create(Laspatule::Models::CreateIngredient.new(name: "courgette"))
      repo.create(Laspatule::Models::CreateIngredient.new(name: "concombre"))
      repo.create(Laspatule::Models::CreateIngredient.new(name: "olive"))
      potiron_id = repo.create(Laspatule::Models::CreateIngredient.new(name: "potiron"))
      onglet_id = repo.create(Laspatule::Models::CreateIngredient.new(name: "onglet"))

      it "returns an empty list when there is no result" do
        repo.search_by_name("nop", 10).content.size.should eq(0)
      end

      it "returns all matching ingredients on a single page if possible" do
        page = repo.search_by_name("on", 10)
        page.content.size.should eq(5)
        page.next_page.should be_nil
        page.content.map { |i| i.name }.should eq(["oignon", "onglet", "poivron", "potiron", "concombre"])
      end

      it "returns many pages ordered by (name length, id) if there is too many results" do
        page = repo.search_by_name("on", 2)
        page.content.size.should eq(2)
        page.next_page.should eq("6_#{onglet_id}")
        page.content.map { |i| i.name }.should eq(["oignon", "onglet"])

        page = repo.search_by_name("on", 2, page.next_page)
        page.content.size.should eq(2)
        page.next_page.should eq("7_#{potiron_id}")
        page.content.map { |i| i.name }.should eq(["poivron", "potiron"])

        page = repo.search_by_name("on", 2, page.next_page)
        page.content.size.should eq(1)
        page.next_page.should be_nil
        page.content.map { |i| i.name }.should eq(["concombre"])
      end

      it "returns an empty page without next_page if page_size is 0" do
        page = repo.search_by_name("on", 0)
        page.content.size.should eq(0)
        page.next_page.should be_nil
      end
    end
  end
end
