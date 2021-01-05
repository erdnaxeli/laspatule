module Laspatule::Repositories::DB::Migrations::V001
  def self.version
    1
  end

  def self.sql
    %(
      CREATE TABLE ingredient (
        id INTEGER PRIMARY KEY
        , created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        , name TEXT(100) UNIQUE NOT NULL
      );
      CREATE TABLE recipe (
        id INTEGER PRIMARY KEY
        , created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        , title TEXT(100) NOT NULL
      );
      CREATE TABLE recipe_section (
        id INTEGER PRIMARY KEY
        , created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        , title TEXT(100) NOT NULL
        , recipe_id INTEGER NOT NULL
          REFERENCES recipe (id) ON DELETE CASCADE
      );
      CREATE TABLE recipe_step(
        id INTEGER PRIMARY_KEY
        , created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        , instruction TEXT(512) NOT NULL
        , section_id INTEGER NOT NULL
          REFERENCES recipe_section (id) ON DELETE CASCADE
      );
      CREATE TABLE recipe_ingredient (
        id INTEGER PRIMARY KEY
        , created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        , quantity TEXT(50)
        , ingredient_id INTEGER NOT NULL
          REFERENCES ingredient (id) ON DELETE RESTRICT
        , recipe_id INTEGER NOT NULL
          REFERENCES recipe (id) ON DELETE CASCADE
      );
    )
  end
end
