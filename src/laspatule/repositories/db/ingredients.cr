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

  def search_by_name(name : String, page_size : Int32, next_page previous_page : String? = nil) : Models::Page(Models::Ingredient)
    if previous_page
      previous_length, previous_id = previous_page.split('_').map &.to_i
      result = @db.query_all(
        "SELECT id, name FROM ingredient WHERE name LIKE ? AND (LENGTH(name), id) > (?, ?) ORDER BY LENGTH(name), id LIMIT ?",
        "%#{name}%",
        previous_length,
        previous_id,
        page_size,
        as: {id: Int32, name: String},
      )
    else
      result = @db.query_all(
        "SELECT id, name FROM ingredient WHERE name LIKE ? ORDER BY LENGTH(name), id LIMIT ?",
        "%#{name}%",
        page_size,
        as: {id: Int32, name: String},
      )
    end

    content = result.map { |r| Models::Ingredient.new(**r) }
    if content.size < page_size
      next_page = nil
    elsif last_item = content.last?
      next_page = "#{last_item.name.size}_#{last_item.id}"
    end

    Models::Page(Models::Ingredient).new(content: content, next_page: next_page)
  end
end
