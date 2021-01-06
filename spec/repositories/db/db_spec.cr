require "./spec_helper"

describe Laspatule::Repositories::DB do
  config = Laspatule::Repositories::DB::Config.new(
    uri: "sqlite3://%3Amemory%3A?cache=shared"
  )

  describe ".open" do
    it "returns a new Database object" do
      db = Laspatule::Repositories::DB.open(config)
      db.class.should eq(DB::Database)
      db.close
    end
  end

  describe ".migrate" do
    it "runs without failing" do
      db = Laspatule::Repositories::DB.open(config)
      Laspatule::Repositories::DB.migrate(db)
    end
  end
end
