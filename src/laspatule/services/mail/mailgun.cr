require "http/client"
require "yaml"

require "../mail"

class Laspatule::Services::Mail::Mailgun
  include Services::Mail

  record Config, api_url : String, api_token : String do
    include YAML::Serializable
  end

  def initialize(@config : Config)
  end

  def send_mail(from : String, to : String, subject : String, text : String) : Nil
    response = HTTP::Client.post(
      "https://api:#{@config.api_token}@#{@config.api_url}",
      headers: HTTP::Headers{"Content-type" => "application/json"},
      body: {
        from: from,
        to: to,
        subject: subject,
        text: text,
      }
    )
  end
end
