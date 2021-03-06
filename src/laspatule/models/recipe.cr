record(
  Laspatule::Models::Recipe,
  id : Int32,
  title : String,
  user : User,
  ingredients = Array(Laspatule::Models::Recipe::Ingredient).new,
  sections = Array(Laspatule::Models::Recipe::Section).new
) do
  include JSON::Serializable
end
