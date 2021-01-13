require "./spec_helper"

describe Laspatule::Models::CreateRecipe::CreateSection do
  describe ".new" do
    it "creates a new CreateSection" do
      section = Laspatule::Models::CreateRecipe::CreateSection.new(
        title: "L'aubergine",
        steps: Array(Laspatule::Models::CreateRecipe::CreateStep).new,
      )
      section.title.should eq("L'aubergine")
      section.steps.size.should eq(0)
    end
  end

  describe ".from_json" do
    it "returns a new CreateSection from json" do
      section = Laspatule::Models::CreateRecipe::CreateSection.from_json(
        %(
          {
            "title": "L'aubergine",
            "steps": []
          }
        )
      )
      section.class.should eq(Laspatule::Models::CreateRecipe::CreateSection)
      section.title.should eq("L'aubergine")
      section.steps.size.should eq(0)
    end
  end

  describe "#validate" do
    it "returns no error when there is not" do
      section = Laspatule::Models::CreateRecipe::CreateSection.new(
        title: "L'aubergine",
        steps: [CREATE_STEP],
      )
      section.validate.size.should eq(0)
    end

    it "returns an error when the title is too short" do
      section = Laspatule::Models::CreateRecipe::CreateSection.new(
        title: "",
        steps: [CREATE_STEP],
      )
      errors = section.validate

      errors.size.should eq(1)
      errors["title"].size.should eq(1)
      errors["title"][0].should eq(Laspatule::Models::Validation::Error::TooShort)
    end

    it "returns an error when the title is too long" do
      section = Laspatule::Models::CreateRecipe::CreateSection.new(
        title: "*" * 101,
        steps: [CREATE_STEP],
      )
      errors = section.validate

      errors.size.should eq(1)
      errors["title"].size.should eq(1)
      errors["title"][0].should eq(Laspatule::Models::Validation::Error::TooLong)
    end

    it "returns an error correctly indexed when a step is wrong" do
      invalid_step = Laspatule::Models::CreateRecipe::CreateStep.new(
        instruction: "",
      )
      section = Laspatule::Models::CreateRecipe::CreateSection.new(
        title: "L'aubergine",
        steps: [
          CREATE_STEP,
          invalid_step,
        ]
      )
      errors = section.validate

      errors.size.should eq(1)
      errors["steps"].size.should eq(1)
      errors["steps"][1].should eq(invalid_step.validate)
    end

    it "returns an error when there is no step" do
      section = Laspatule::Models::CreateRecipe::CreateSection.new(
        title: "L'aubergine",
        steps: Array(Laspatule::Models::CreateRecipe::CreateStep).new,
      )
      errors = section.validate
      errors.size.should eq(1)
      errors["steps"].size.should eq(1)
      errors["steps"][0].should eq(Laspatule::Models::Validation::Error::TooShort)
    end
  end
end
