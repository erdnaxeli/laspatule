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
end
