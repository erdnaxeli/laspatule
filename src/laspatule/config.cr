require "file"
require "yaml"

require "./repositories/db"

record(
  Laspatule::Config,
  db : Repositories::DB::Config
) do
  include YAML::Serializable

  def self.read(filename) : self
    from_yaml(File.read(filename))
  end
end
