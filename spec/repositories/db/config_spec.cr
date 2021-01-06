require "./spec_helper"

describe Laspatule::Repositories::DB::Config do
  describe ".new" do
    it "returns a new Config object" do
      config = Laspatule::Repositories::DB::Config.new(uri: "some uri")
      config.uri.should eq("some uri")
    end
  end
end
