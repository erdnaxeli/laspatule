require "./validation"

record(
  Laspatule::Models::CreateRecipe,
  title : String,
  ingredients : Array(CreateRecipe::CreateIngredient),
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
    errors = Array(Validation::Error).new.tap do |errors|
      too_short(errors, @ingredients, 0)
      too_long(errors, @ingredients, 30)
    end

    if errors.size > 0
      errors
    else
      errors = errors_from(@ingredients)
      if errors.is_a?(Array(Validation::Error))
        # errors is empty
        errors = Hash(String | UInt8, Validation::ValidationError).new
      end

      ingredients_ids = @ingredients.map { |i| i.ingredient_id }
      @ingredients.each_with_index do |ingredient, idx|
        if ingredients_ids[...idx].includes?(ingredient.ingredient_id)
          errors[idx.to_u8] = [Validation::Error::DuplicatedElement]
        end
      end

      errors
    end
  end

  private def validate_sections
    errors = Array(Validation::Error).new.tap do |errors|
      too_short(errors, @sections, 0)
      too_long(errors, @sections, 5)
    end

    if errors.size > 0
      errors
    else
      errors_from(@sections)
    end
  end
end
