module Laspatule::Services::Mail
  # Sends a mail to the given *recipient*.
  abstract def send_mail(from : String, to : String, subject : String, text : String) : Nil
end
