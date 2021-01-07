require "./validation"

record(
  Laspatule::Models::CreateIngredient,
  name : String
) do
  include JSON::Serializable
  include Validation::Validate

  private def validate_name
    Array(Validation::Error).new.tap do |errors|
      too_long(errors, @name, 100)
      too_short(errors, @name, 0)
    end
  end
end
