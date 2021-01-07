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

  describe "#validate" do
    it "returns no error when there is not" do
      step = Laspatule::Models::CreateRecipe::CreateStep.new(
        instruction: "couper l'aubergine en morceaux",
      )

      step.validate.size.should eq(0)
    end

    it "returns an error when the instruction is too short" do
      step = Laspatule::Models::CreateRecipe::CreateStep.new(instruction: "")
      errors = step.validate

      errors.size.should eq(1)
      errors["instruction"].size.should eq(1)
      errors["instruction"][0].should eq(Laspatule::Models::Validation::Error::TooShort)
    end

    it "returns an error when the instruction is too long" do
      step = Laspatule::Models::CreateRecipe::CreateStep.new(instruction: "*" * 513)
      errors = step.validate

      errors.size.should eq(1)
      errors["instruction"].size.should eq(1)
      errors["instruction"][0].should eq(Laspatule::Models::Validation::Error::TooLong)
    end
  end
end
