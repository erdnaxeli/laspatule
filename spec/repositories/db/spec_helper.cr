require "./spec_helper"

def with_db
  config = Laspatule::Repositories::DB::Config.new(
    uri: "sqlite3://%3Amemory%3A"
  )
  db = Laspatule::Repositories::DB.open(config)
  Laspatule::Repositories::DB.migrate(db)
  yield db
end

def with_ingredient_repo
  with_db do |db|
    repo = Laspatule::Repositories::DB::Ingredients.new(db)
    yield repo, db
  end
end
