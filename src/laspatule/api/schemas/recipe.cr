require "json"

require "../../models"

struct Laspatule::API::Schemas::Recipe
  include JSON::Serializable

  getter id : Int32
  getter title : String
  getter user : Models::User
  getter ingredients : Array(Ingredient)
  getter sections : Array(Models::Recipe::Section)

  def initialize(recipe : Models::Recipe)
    @id = recipe.id
    @title = recipe.title
    @user = recipe.user
    @ingredients = recipe.ingredients.map { |i| Ingredient.new(i) }
    @sections = recipe.sections
  end
end

struct Laspatule::API::Schemas::Recipe::Ingredient
  include JSON::Serializable

  getter id : Int32
  getter name : String
  getter quantity : String

  def initialize(ingredient : Models::Recipe::Ingredient)
    @id = ingredient.ingredient.id
    @name = ingredient.ingredient.name
    @quantity = ingredient.quantity
  end
end
