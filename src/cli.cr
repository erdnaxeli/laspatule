require "option_parser"

require "./laspatule"

config = Laspatule::Config.read("config.yaml")
db = Laspatule::Repositories::DB.open(config.db)
Laspatule::Repositories::DB.migrate(db)
users_repo = Laspatule::Repositories::DB::Users.new(db)
users_service = Laspatule::Services::Users.new(users_repo)

OptionParser.parse do |parser|
  parser.banner = "Usage: cli COMMAND"
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  parser.on("user", "create a new user") do
    parser.banner = "Usage: cli create-user NAME EMAIL"
    parser.unknown_args do |args|
      if args.size != 2
        puts parser
        exit
      else
        name, email = args
        user = Laspatule::Models::CreateUser.new(
          name: name,
          email: email,
        )
        users_service.create(user)
        puts "New user created."
      end
    end
  end
end
