module Laspatule::Repositories::DB::Migrations::V001
  def self.version
    1
  end

  def self.sql
    %(
      CREATE TABLE user (
        id INTEGER PRIMARY KEY
        , created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        , enabled BOOLEAN DEFAULT false
        , name TEXT(100) NOT NULL
        , email TEXT(100) UNIQUE NOT NULL
        , password TEXT(100)
      );
      CREATE INDEX user_id_idx ON user (id);
      CREATE TABLE password_reinit(
        id INTEGER PRIMARY KEY
        , created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        , token TEXT(100) NOT NULL
        , user_id INTEGER NOT NULL
          REFERENCES user (id) ON DELETE CASCADE
      );
      CREATE INDEX password_reinit_user_id_idx ON password_reinit (user_id);
      CREATE TABLE ingredient (
        id INTEGER PRIMARY KEY
        , created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        , name TEXT(100) UNIQUE NOT NULL
          CHECK (0 < LENGTH(name) AND LENGTH(name) < 100)
      );
      CREATE INDEX ingredient_id_idx ON ingredient (id);
      CREATE TABLE recipe (
        id INTEGER PRIMARY KEY
        , created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        , title TEXT(100) NOT NULL
        , user_id INTEGER NOT NULL
          REFERENCES user (id) ON DELETE RESTRICT
        , UNIQUE (title, user_id)
      );
      CREATE INDEX recipe_id_idx ON recipe (id);
      CREATE TABLE recipe_section (
        id INTEGER PRIMARY KEY
        , created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        , title TEXT(100) NOT NULL
        , recipe_id INTEGER NOT NULL
          REFERENCES recipe (id) ON DELETE CASCADE
        , position INTEGER NOT NULL
        , UNIQUE(recipe_id, position)
      );
      CREATE INDEX recipe_section_recipe_id_idx ON recipe_section (recipe_id);
      CREATE TABLE recipe_step(
        id INTEGER PRIMARY KEY
        , created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        , instruction TEXT(512) NOT NULL
        , section_id INTEGER NOT NULL
          REFERENCES recipe_section (id) ON DELETE CASCADE
        , position INTEGER NOT NULL
        , UNIQUE(section_id, position)
      );
      CREATE INDEX recipe_step_section_id_idx ON recipe_step (section_id);
      CREATE TABLE recipe_ingredient (
        id INTEGER PRIMARY KEY
        , created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        , quantity TEXT(50)
        , ingredient_id INTEGER NOT NULL
          REFERENCES ingredient (id) ON DELETE RESTRICT
        , recipe_id INTEGER NOT NULL
          REFERENCES recipe (id) ON DELETE CASCADE
      );
      CREATE INDEX recipe_ingredient_recipe_id_idx ON recipe_ingredient (recipe_id);
    )
  end
end
