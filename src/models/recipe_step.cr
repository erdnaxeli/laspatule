record(
  Laspatule::Models::Recipe::Step,
  id : Int32,
  instruction : String
) do
  include JSON::Serializable
end
