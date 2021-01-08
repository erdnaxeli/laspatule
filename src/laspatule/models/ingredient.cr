record(
  Laspatule::Models::Ingredient,
  id : Int32,
  name : String
) do
  include JSON::Serializable
end
