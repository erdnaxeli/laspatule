require "db"

require "../ingredients"

class Laspatule::Repositories::DB::Ingredients
  include Laspatule::Repositories::Ingredients

  def initialize(@db : ::DB::Database)
  end

  def create(ingredient : Models::CreateIngredient) : Int32
    @db.transaction do |tx|
      cnn = tx.connection
      begin
        er = cnn.exec("INSERT INTO ingredient (name) VALUES (?)", ingredient.name)
        tx.commit
        return er.last_insert_id.to_i
      rescue e : SQLite3::Exception
        if e.code == 19 && e.message.try &.includes?("UNIQUE")
          raise DuplicatedIngredientError.new(
            "Ingredient #{ingredient.name} already exists"
          )
        else
          raise e
        end
      end
    end
    raise "BUG: unreachable"
  end

  def get_by_id(id : Int32) : Models::Ingredient
    result = @db.query_one(
      "SELECT id, name FROM ingredient WHERE id = ?",
      id,
      as: {id: Int32, name: String},
    )
    Models::Ingredient.new(**result)
  rescue ::DB::NoResultsError
    raise Ingredients::IngredientNotFoundError.new("Ingredient with id #{id} not found")
  end

  def search_by_name(name : String, page_size : Int32, next_page previous_page : Int32? = nil) : Models::Page(Ingredient)
    Models::Page(Ingredient).new(content: Array(Ingredient).new, next_page: 0)
  end
end