record(
  Laspatule::Models::CreateRecipe,
  title : String,
  ingredients : Array(Int32),
  sections : Array(CreateSection)
) do
  include JSON::Serializable
end
