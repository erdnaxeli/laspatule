require "./validation"

record(
  Laspatule::Models::CreateRecipe::CreateStep,
  instruction : String
) do
  include JSON::Serializable
  include Validation::Validate

  private def validate_instruction
    Array(Validation::Error).new.tap do |errors|
      too_long(errors, @instruction, 512)
      too_short(errors, @instruction, 0)
    end
  end
end
