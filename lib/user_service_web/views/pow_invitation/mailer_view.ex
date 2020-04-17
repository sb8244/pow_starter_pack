defmodule UserServiceWeb.PowInvitation.MailerView do
  use UserServiceWeb, :mailer_view

  def subject(:invitation, _assigns), do: "You've been invited"
end
