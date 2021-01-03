record(
  Laspatule::Models::CreateRecipe::CreateSection,
  title : String,
  steps : Array(CreateStep)
) do
  include JSON::Serializable
end
