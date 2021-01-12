require "db"

require "../recipes"

class Laspatule::Repositories::DB::Recipes
  include Laspatule::Repositories::Recipes

  def initialize(@db : ::DB::Database)
  end

  def create(recipe : Models::CreateRecipe, user_id : Int32) : Int32
    cnn = @db.checkout
    begin
      cnn.exec("PRAGMA foreign_keys = ON")
      cnn.transaction do |tx|
        recipe_id = insert_recipe(cnn, recipe.title, user_id)
        recipe.ingredients.each do |ingredient|
          insert_recipe_ingredient(
            cnn,
            recipe_id,
            ingredient.quantity,
            ingredient.ingredient_id,
          )
        end
        recipe.sections.each do |section|
          section_id = insert_recipe_section(cnn, recipe_id, section.title)

          section.steps.each do |step|
            insert_recipe_step(cnn, section_id, step.instruction)
          end
        end

        tx.commit
        return recipe_id
      end
      raise "BUG: unreachable"
    ensure
      cnn.release
    end
  end

  def get_by_id(id : Int32) : Models::Recipe
    Models::Recipe.new(
      id: 42,
      title: "Ratatouille",
      user: Laspatule::Models::User.new(id: 1, name: "user"),
    )
  end

  def get_all(page_size : Int32, next_page previous_page : Int32?) : Models::Page(Models::Recipe)
    Models::Page(Models::Recipe).new(
      content: Array(Models::Recipe).new,
      next_page: nil,
    )
  end

  private def insert_recipe(cnn, title, user_id) : Int32
    er = cnn.exec("INSERT INTO recipe (title, user_id) VALUES (?, ?)", title, user_id)
    er.last_insert_id.to_i
  rescue e : SQLite3::Exception
    if e.code == 19 && e.message.try &.includes?("UNIQUE")
      raise DuplicatedRecipeError.new(
        "Recipe #{title} by this user already exists"
      )
    else
      raise e
    end
  end

  private def insert_recipe_ingredient(cnn, recipe_id : Int32, quantity : String, ingredient_id : Int32) : Nil
    cnn.exec(
      "
        INSERT INTO recipe_ingredient (quantity, ingredient_id, recipe_id)
        VALUES (?, ?, ?)
      ",
      quantity,
      ingredient_id,
      recipe_id,
    )
  end

  private def insert_recipe_section(cnn, recipe_id : Int32, title : String) : Int32
    er = cnn.exec(
      "
        INSERT INTO recipe_section (title, recipe_id)
        VALUES (?, ?)
      ",
      title,
      recipe_id,
    )
    er.last_insert_id.to_i
  end

  private def insert_recipe_step(cnn, section_id : Int32, instruction : String) : Nil
    cnn.exec(
      "
        INSERT INTO recipe_step (section_id, instruction)
        VALUES (?, ?)
      ",
      section_id,
      instruction,
    )
  end
end
