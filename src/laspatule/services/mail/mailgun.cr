require "http/client"
require "uri"
require "yaml"

require "../mail"

class Laspatule::Services::Mail::Mailgun
  include Services::Mail

  record(
    Config,
    api_url : String,
    api_token : String,
    from : String
  ) do
    include YAML::Serializable
  end

  def initialize(@config : Config)
  end

  def send(to : String, subject : String, text : String) : Nil
    form = String.build do |str|
      str << "from=" << URI.encode_www_form(@config.from)
      str << "&to=" << URI.encode_www_form(to)
      str << "&subject=" << URI.encode_www_form(subject)
      str << "&text=" << URI.encode_www_form(text)
    end

    response = HTTP::Client.post(
      "https://api:#{@config.api_token}@#{@config.api_url}/messages",
      form: form,
    )

    if !response.success?
      raise "Error: #{response.body?}"
    end
  end
end
