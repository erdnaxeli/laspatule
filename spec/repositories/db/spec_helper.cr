require "../spec_helper"

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

def with_recipes_repo
  with_ingredient_repo do |ingredients, db|
    db.exec(
      "INSERT INTO user (id, name, email) VALUES (?, ?, ?)",
      12, "douze", "douze@twelve.com",
    )
    db.exec(
      "INSERT INTO user (id, name, email) VALUES (?, ?, ?)",
      13, "treize", "treize@twelve.com",
    )
    repo = Laspatule::Repositories::DB::Recipes.new(db)
    yield repo, ingredients, db
  end
end
