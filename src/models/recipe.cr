record(
  Laspatule::Models::Recipe,
  id : Int32,
  title : String,
  ingredients = Array(Laspatule::Models::Recipe::Ingredient).new,
  sections = Array(Laspatule::Models::Recipe::Section).new,
)
