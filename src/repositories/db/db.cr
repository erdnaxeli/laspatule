require "sqlite3"

require "./*"

# Interface for database access.
class Laspatule::Repositories::DB
  @db : ::DB::Database

  # Creates a new DB object for the given *config*.
  def initialize(config : Config)
    @db = ::DB.open(config.uri)
  end

  # Open a new transaction and yield it.
  def transaction
    @db.transaction do |tx|
      yield tx
    end
  end
end
