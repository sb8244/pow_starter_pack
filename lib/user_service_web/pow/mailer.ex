defmodule UserServiceWeb.Pow.Mailer do
  use Pow.Phoenix.Mailer
  use Bamboo.Mailer, otp_app: :user_service

  import Bamboo.Email

  @impl true
  def cast(%{user: user, subject: subject, text: text, html: html}) do
    new_email(
      to: user.email,
      from: from_address(),
      subject: subject,
      html_body: html,
      text_body: text
    )
  end

  @impl true
  def process(email) do
    deliver_now(email)
  end

  defp from_address() do
    Application.fetch_env!(:user_service, __MODULE__)
    |> Keyword.fetch!(:from_address)
  end
end
