require "./spec_helper"

describe Laspatule::Models::Validation::Error do
  describe "#to_json" do
    it "serializes an Error to json as underscore string" do
      error = Laspatule::Models::Validation::Error::TooLong.to_json
      error.should eq(%("too_long"))
    end
  end
end
