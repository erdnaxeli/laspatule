require "./spec_helper"

describe Laspatule::Models::Recipe::Section do
  it "can be created without steps" do
    section = Laspatule::Models::Recipe::Section.new(id: 42, title: "rien")
    section.id.should eq(42)
    section.title.should eq("rien")
    section.steps.size.should eq(0)
  end

  it "can be created with steps" do
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
