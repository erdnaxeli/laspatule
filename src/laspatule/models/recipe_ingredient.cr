record(
  Laspatule::Models::Recipe::Ingredient,
  id : Int32,
  quantity : String,
  ingredient : Laspatule::Models::Ingredient
) do
  include JSON::Serializable
end
