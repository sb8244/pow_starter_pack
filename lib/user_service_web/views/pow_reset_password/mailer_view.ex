defmodule UserServiceWeb.PowResetPassword.MailerView do
  use UserServiceWeb, :mailer_view

  def subject(:reset_password, _assigns), do: "APP_NAME: Reset password link"
end
