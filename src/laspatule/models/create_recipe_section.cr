require "./validation"

record(
  Laspatule::Models::CreateRecipe::CreateSection,
  title : String,
  steps : Array(CreateStep)
) do
  include JSON::Serializable
  include Validation::Validate

  private def validate_title
    Array(Validation::Error).new.tap do |errors|
      too_long(errors, @title, 100)
      too_short(errors, @title, 0)
    end
  end

  private def validate_steps
    errors = Array(Validation::Error).new
    too_short(errors, @steps, 0)

    if errors.size > 0
      errors
    else
      errors_from(@steps)
    end
  end
end
