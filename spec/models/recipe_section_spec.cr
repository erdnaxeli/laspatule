require "./spec_helper"

describe Laspatule::Models::Recipe::Section do
  describe ".new" do
    it "creates a Section without steps" do
      section = Laspatule::Models::Recipe::Section.new(id: 42, title: "rien")
      section.id.should eq(42)
      section.title.should eq("rien")
      section.steps.size.should eq(0)
    end

    it "creates a Section steps" do
      section = Laspatule::Models::Recipe::Section.new(
        id: 42,
        title: "L'aubergine",
        steps: [STEP1, STEP2],
      )
      section.id.should eq(42)
      section.title.should eq("L'aubergine")
      section.steps.size.should eq(2)
    end
  end

  describe ".from_json" do
    it "returns a Section from json" do
      section = Laspatule::Models::Recipe::Section.from_json(%(
        {
          "id": 42,
          "title": "L'aubergine",
          "steps": [
            {
              "id": 1,
              "instruction": "couper l'aubergine en morceaux"
            }
          ]
        }
      ))
      section.class.should eq(Laspatule::Models::Recipe::Section)
      section.id.should eq(42)
      section.title.should eq("L'aubergine")
      section.steps.size.should eq(1)
    end
  end

  describe "#to_json" do
    json = SECTION.to_json
    json.should eq(%({"id":1,"title":"L'aubergine","steps":[]}))
  end
end
