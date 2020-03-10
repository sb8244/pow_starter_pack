defmodule UserServiceWeb.PowEmailConfirmation.MailerView do
  use UserServiceWeb, :mailer_view

  def subject(:email_confirmation, _assigns), do: "Welcome to APP_NAME!"
end
