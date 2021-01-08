require "json"

module Laspatule::Models::Validation
  enum Error
    DuplicatedElements
    TooLong
    TooShort

    def to_json(json : JSON::Builder)
      json.string(self.to_s.underscore)
    end
  end

  alias ValidationError = Array(Error) | Hash(String | UInt8, ValidationError)

  module Validate
    def validate : Hash(String | UInt8, ValidationError)
      errors = Hash(String | UInt8, ValidationError).new

      {% for attr in @type.instance_vars %}
        if (field_errors = validate_{{attr.id}}).size > 0
          errors[{{attr.stringify}}] = field_errors
        end
      {% end %}

      errors
    end

    private def errors_from(value) : ValidationError
      case value
      when Array
        errors = Hash(String | UInt8, ValidationError).new

        value.each_with_index do |elt, idx|
          if (elt_errors = elt.validate).size > 0
            errors[idx.to_u8] = elt_errors
          end
        end

        if errors.size > 0
          errors
        else
          Array(Error).new
        end
      else
        if (errors = value.validate).size > 0
          errors
        else
          Array(Error).new
        end
      end
    end

    private def too_long(errors, value, max) : Nil
      if value.size > max
        errors << Error::TooLong
      end
    end

    private def too_short(errors, value, min) : Nil
      if value.size <= min
        errors << Error::TooShort
      end
    end
  end
end
