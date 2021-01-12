require "./validation"

record(
  Laspatule::Models::CreateRecipe::CreateIngredient,
  quantity : String,
  ingredient_id : Int32
) do
  include JSON::Serializable
  include Validation::Validate

  private def validate_quantity
    Array(Validation::Error).new.tap do |errors|
      too_long(errors, @quantity, 100)
      too_short(errors, @quantity, 0)
    end
  end
end
