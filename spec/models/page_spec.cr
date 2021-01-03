require "./spec_helper"

describe Laspatule::Models::Page do
  describe ".new" do
    it "creates a new Page" do
      page = Laspatule::Models::Page(Int32).new(content: [1, 2], next_page: 2)
      page.content.should eq([1, 2])
      page.next_page.should eq(2)
    end
  end
end
