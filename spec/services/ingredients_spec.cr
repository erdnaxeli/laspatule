require "./spec_helper"

describe Laspatule::Services::Ingredients do
  repository = IngredientRepoMock.new
  service = Laspatule::Services::Ingredients.new(1, repository)

  after_each do
    repository.reset
  end

  describe "#creates" do
    it "creates a new ingredient" do
      id = service.create(
        Laspatule::Models::CreateIngredient.new(name: "aubergine")
      )

      id.should eq(1)
      repository.calls["create"].size.should eq(1)
      repository.calls["create"][0].size.should eq(1)
      ingredient = repository.calls["create"][0]["ingredient"].as(Laspatule::Models::CreateIngredient)
      ingredient.name.should eq("aubergine")
    end
  end

  describe "#get_by_id" do
    it "gets an ingredient by id" do
      service.get_by_id(42)

      repository.calls["get_by_id"].size.should eq(1)
      repository.calls["get_by_id"][0].size.should eq(1)
      id = repository.calls["get_by_id"][0]["id"].as(Int32)
      id.should eq(42)
    end
  end
end
