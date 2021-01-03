require "./spec_helper"

describe Laspatule::Models::Recipe::Step do
  describe ".new" do
    it "creates a new Step" do
      step = Laspatule::Models::Recipe::Step.new(id: 42, instruction: "Faire revenir l'aubergine")
      step.id.should eq(42)
      step.instruction.should eq("Faire revenir l'aubergine")
    end
  end

  describe ".from_json" do
    it "returns a Step from json" do
      step = Laspatule::Models::Recipe::Step.from_json(%(
        {
          "id": 42,
          "instruction": "Faire revenir l'aubergine"
        }
      ))
      step.class.should eq(Laspatule::Models::Recipe::Step)
      step.id.should eq(42)
      step.instruction.should eq("Faire revenir l'aubergine")
    end
  end

  describe "#to_json" do
    it "serializes a Step to json" do
      json = STEP1.to_json
      json.should eq(%({"id":1,"instruction":"couper l'aubergine en morceaux"}))
    end
  end
end
