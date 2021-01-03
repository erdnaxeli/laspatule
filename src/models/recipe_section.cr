record(
  Laspatule::Models::Recipe::Section,
  id : Int32,
  title : String,
  steps = Array(Laspatule::Models::Recipe::Step).new
) do
  include JSON::Serializable
end
