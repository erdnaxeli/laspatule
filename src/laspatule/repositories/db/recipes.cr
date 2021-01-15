require "db"

require "../recipes"

class Laspatule::Repositories::DB::Recipes
  include Laspatule::Repositories::Recipes

  alias RecipeRow = {recipe_id: Int64, recipe_title: String, user_id: Int64, user_name: String, recipe_ingredient_id: Int64, recipe_ingredient_quantity: String, ingredient_id: Int64, ingredient_name: String, section_id: Int64, section_title: String, step_id: Int64, step_instruction: String}

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
        recipe.sections.each_with_index do |section, section_position|
          section_id = insert_recipe_section(
            cnn,
            recipe_id,
            section.title,
            section_position,
          )

          section.steps.each_with_index do |step, step_position|
            insert_recipe_step(cnn, section_id, step.instruction, step_position)
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
    rows = @db.query_all(
      "
        SELECT
          recipe.id
          , recipe.title
          , user.id
          , user.name
          , recipe_ingredient.id
          , recipe_ingredient.quantity
          , ingredient.id
          , ingredient.name
          , recipe_section.id
          , recipe_section.title
          , recipe_step.id
          , recipe_step.instruction
        FROM recipe
        JOIN user ON recipe.user_id = user.id
        JOIN recipe_ingredient ON recipe.id = recipe_ingredient.recipe_id
        JOIN ingredient ON recipe_ingredient.ingredient_id = ingredient.id
        JOIN recipe_section ON recipe.id = recipe_section.recipe_id
        JOIN recipe_step ON recipe_section.id = recipe_step.section_id
        WHERE recipe.id = ?
        ORDER BY recipe_section.position, recipe_step.position
      ",
      id,
      as: {
        recipe_id:                  Int64,
        recipe_title:               String,
        user_id:                    Int64,
        user_name:                  String,
        recipe_ingredient_id:       Int64,
        recipe_ingredient_quantity: String,
        ingredient_id:              Int64,
        ingredient_name:            String,
        section_id:                 Int64,
        section_title:              String,
        step_id:                    Int64,
        step_instruction:           String,
      },
    )

    if rows.size == 0
      raise RecipeNotFoundError.new
    else
      build_recipes(rows)[0]
    end
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

  private def insert_recipe_section(cnn, recipe_id : Int32, title : String, position : Int32) : Int32
    er = cnn.exec(
      "
        INSERT INTO recipe_section (title, recipe_id, position)
        VALUES (?, ?, ?)
      ",
      title,
      recipe_id,
      position,
    )
    er.last_insert_id.to_i
  end

  private def insert_recipe_step(cnn, section_id : Int32, instruction : String, position : Int32) : Nil
    cnn.exec(
      "
        INSERT INTO recipe_step (section_id, instruction, position)
        VALUES (?, ?, ?)
      ",
      section_id,
      instruction,
      position,
    )
  end

  private def build_recipes(rows : Array(RecipeRow)) : Array(Models::Recipe)
    recipes = Hash(Int32, Models::Recipe).new
    recipe_ingredients = Hash(Int32, Tuple(Models::Recipe::Ingredient, Int32)).new
    sections = Hash(Int32, Tuple(Models::Recipe::Section, Int32)).new
    steps = Hash(Int32, Tuple(Models::Recipe::Step, Int32)).new

    rows.each do |row|
      recipes[row["recipe_id"].to_i] = Models::Recipe.new(
        id: row["recipe_id"].to_i,
        title: row["recipe_title"],
        user: Models::User.new(
          id: row["user_id"].to_i,
          name: row["user_name"],
        )
      )
      recipe_ingredients[row["recipe_ingredient_id"].to_i] = {
        Models::Recipe::Ingredient.new(
          id: row["recipe_ingredient_id"].to_i,
          quantity: row["recipe_ingredient_quantity"],
          ingredient: Models::Ingredient.new(
            id: row["ingredient_id"].to_i,
            name: row["ingredient_name"],
          ),
        ),
        row["recipe_id"].to_i,
      }
      sections[row["section_id"].to_i] = {
        Models::Recipe::Section.new(
          id: row["section_id"].to_i,
          title: row["section_title"],
        ),
        row["recipe_id"].to_i,
      }
      steps[row["step_id"].to_i] = {
        Models::Recipe::Step.new(
          id: row["step_id"].to_i,
          instruction: row["step_instruction"],
        ),
        row["section_id"].to_i,
      }
    end

    steps.each_value do |step, section_id|
      sections[section_id][0].steps << step
    end
    sections.each_value do |section, recipe_id|
      recipes[recipe_id].sections << section
    end
    recipe_ingredients.each_value do |ingredient, recipe_id|
      recipes[recipe_id].ingredients << ingredient
    end

    recipes.values
  end
end
