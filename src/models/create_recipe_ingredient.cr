record(
  Laspatule::Models::CreateRecipe::CreateRecipeIngredient,
  quantity : String,
  ingredient : Laspatule::Models::CreateIngredient
) do
  include JSON::Serializable
end
