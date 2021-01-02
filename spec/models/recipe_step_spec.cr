require "./spec_helper"

describe Laspatule::Models::Recipe::Step do
  it "can be created" do
    step = Laspatule::Models::Recipe::Step.new(id: 42, instruction: "Faire revenir l'aubergine")
    step.id.should eq(42)
    step.instruction.should eq("Faire revenir l'aubergine")
  end
end
