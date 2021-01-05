require "sqlite3"

require "./*"
require "./migrations/*"

module Laspatule::Repositories::DB
  # Creates a new DB object for the given *config*.
  def self.open(config : Config) : ::DB::Database
    ::DB.open(config.uri)
  end

  MIGRATIONS = [
    Migrations::V001,
  ]

  # TODO: this should be checked at compile time rather than run time.
  MIGRATIONS.each_with_index do |m, i|
    raise "Migrations are not consistent" if m.version != i + 1
  end

  def self.migrate(db : ::DB::Database)
    if !version_table_exists?(db)
      create_version_table(db)
    end

    version = get_version(db)
    if version.nil?
      apply_migrations(db, MIGRATIONS)
    else
      apply_migrations(db, MIGRATIONS[version..])
    end
  end

  private def self.version_table_exists?(db) : Bool
    begin
      db.query_one(
        "SELECT 1 FROM sqlite_master WHERE type = ? AND name = ?",
        "table",
        "version",
        as: Int32
      )
      true
    rescue ::DB::Error
      false
    end
  end

  private def self.create_version_table(db) : Nil
    db.exec("CREATE TABLE version (version INTEGER)")
  end

  private def self.get_version(db) : Int32?
    db.query_one?("SELECT version FROM version", as: Int64).try &.to_i
  end

  private def self.apply_migrations(db, migrations)
    migrations.each do |migration|
      db.transaction do |tx|
        cnn = tx.connection

        migration.sql.rstrip.split(';').reject("").each do |query|
          cnn.exec(query)
        end

        # I don't want to manage the case of the first migration, when the row
        # does not exist.
        cnn.exec("DELETE FROM version")
        cnn.exec("INSERT INTO version (version) VALUES (?)", migration.version)
      end
    end
  end
end
