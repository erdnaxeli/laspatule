require "./validation"

record(
  Laspatule::Models::CreateRecipe::CreateRecipeIngredient,
  quantity : String,
  ingredient : Laspatule::Models::CreateIngredient
) do
  include JSON::Serializable
  include Validation::Validate

  private def validate_quantity
    Array(Validation::Error).new.tap do |errors|
      too_long(errors, @quantity, 100)
      too_short(errors, @quantity, 0)
    end
  end

  private def validate_ingredient
    errors_from(@ingredient)
  end
end
