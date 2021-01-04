require "yaml"

class Laspatule::Repositories::DB
  record(
    Config,
    uri : String
  ) do
    include YAML::Serializable
  end
end
