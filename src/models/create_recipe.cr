require "./validation"

record(
  Laspatule::Models::CreateRecipe,
  title : String,
  ingredients : Array(Int32),
  sections : Array(CreateSection)
) do
  include JSON::Serializable
  include Validation::Validate

  private def validate_title
    Array(Validation::Error).new.tap do |errors|
      too_long(errors, @title, 100)
      too_short(errors, @title, 0)
    end
  end

  private def validate_ingredients
    Array(Validation::Error).new.tap do |errors|
      if @ingredients.to_set.size != @ingredients.size
        errors << Validation::Error::DuplicatedElements
      end
    end
  end

  private def validate_sections
    errors_from(@sections)
  end
end
