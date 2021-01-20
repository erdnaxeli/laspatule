require "../spec_helper"

class IngredientRepoMock
  include Laspatule::Repositories::Ingredients

  alias Calls = Hash(String, Array(Hash(String, Int32 | Laspatule::Models::CreateIngredient)))

  @calls = Calls.new do |h, k|
    h[k] = Array(Hash(String, Int32 | Laspatule::Models::CreateIngredient)).new
  end

  def calls
    @calls
  end

  def create(ingredient : Laspatule::Models::CreateIngredient) : Int32
    @calls["create"] << {"ingredient" => ingredient} of String => Int32 | Laspatule::Models::CreateIngredient
    1
  end

  def get_by_id(id : Int32) : Laspatule::Models::Ingredient
    @calls["get_by_id"] << {"id" => id} of String => Int32 | Laspatule::Models::CreateIngredient
    Laspatule::Models::Ingredient.new(
      id: 1,
      name: "aubergine",
    )
  end

  def reset : Nil
    @calls = Calls.new do |h, k|
      h[k] = Array(Hash(String, Int32 | Laspatule::Models::CreateIngredient)).new
    end
  end
end

class UserRepoMock
  include Laspatule::Repositories::Users

  def initialize(
    @create_return : Int32? | Exception = nil,
    @get_by_email_return : Laspatule::Models::UserWithPassword? | Exception = nil,
    @get_by_id_return : Laspatule::Models::User? | Exception = nil
  )
  end

  def create(user : Laspatule::Models::CreateUser) : Int32
    raise_or @create_return.not_nil!
  end

  def get_by_email(email : String) : Laspatule::Models::UserWithPassword
    raise_or @get_by_email_return.not_nil!
  end

  def get_by_id(id : Int32) : Laspatule::Models::User
    raise_or @get_by_id_return.not_nil!
  end

  private def raise_or(value)
    if value.is_a?(Exception)
      raise value
    end

    value
  end
end

class RecipesRepoMock
  include Laspatule::Repositories::Recipes

  def initialize(
    @create_return : Int32? = nil,
    @get_all_return : Laspatule::Models::Page(Laspatule::Models::Recipe)? = nil,
    @get_by_id_return : Laspatule::Models::Recipe? = nil
  )
  end

  def create(recipe : Laspatule::Models::CreateRecipe, user_id : Int32) : Int32
    @create_return.not_nil!
  end

  def get_all(page_size : Int32, next_page previous_page : Int32? = nil) : Laspatule::Models::Page(Laspatule::Models::Recipe)
    @get_all_return.not_nil!
  end

  def get_by_id(id : Int32) : Laspatule::Models::Recipe
    @get_by_id_return.not_nil!
  end
end
