require "./spec_helper"

describe Laspatule::Models::CreateRecipe::CreateStep do
  describe ".new" do
    it "creates a new CreateStep" do
      step = Laspatule::Models::CreateRecipe::CreateStep.new(
        instruction: "couper l'aubergine en morceaux",
      )
      step.instruction.should eq("couper l'aubergine en morceaux")
    end
  end

  describe ".from_json" do
    it "returns a new CreateStep from json" do
      step = Laspatule::Models::CreateRecipe::CreateStep.from_json(
        %({"instruction": "couper l'aubergine en morceaux"})
      )
      step.class.should eq(Laspatule::Models::CreateRecipe::CreateStep)
      step.instruction.should eq("couper l'aubergine en morceaux")
    end
  end
end
