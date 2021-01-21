require "file"
require "yaml"

require "./repositories/db"
require "./services/mail/mailgun"

record(
  Laspatule::Config,
  db : Repositories::DB::Config,
  mail : Services::Mail::Mailgun::Config,
) do
  include YAML::Serializable

  def self.read(filename) : self
    from_yaml(File.read(filename))
  end
end
