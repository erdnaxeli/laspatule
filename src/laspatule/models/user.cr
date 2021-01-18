require "time"

record(
  Laspatule::Models::User,
  id : Int32,
  name : String
) do
  include JSON::Serializable
end

record(
  Laspatule::Models::UserWithPassword,
  id : Int32,
  enabled : Bool,
  name : String,
  email : String,
  password : String?,
  reinit_token : String? = nil,
  reinit_at : Time? = nil,
)
