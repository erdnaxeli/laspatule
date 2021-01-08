require "yaml"

record(
  Laspatule::Repositories::DB::Config,
  uri : String
) do
  include YAML::Serializable
end
