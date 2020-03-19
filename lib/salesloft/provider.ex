defmodule SalesLoft.Provider do
  @moduledoc """
  This is here to demonstrate how simple it is to make a custom OAuth provider.

  SalesLoft requires SSL for all redirect URIs for security reasons (except for localhost). Because I'm
  using a custom domain for this, I currently have to run it in SSL mode and things just get really weird
  with the self-signed cert.
  """

  use Assent.Strategy.OAuth2.Base

  @impl true
  def default_config(_config) do
    [
      site: "https://accounts.salesloft.com/",
      authorize_url: "https://accounts.salesloft.com/oauth/authorize",
      token_url: "https://accounts.salesloft.com/oauth/token",
      user_url: "https://api.salesloft.com/v2/me",
      authorization_params: [],
      auth_method: :client_secret_post
    ]
  end

  @impl true
  def normalize(_config, %{"data" => user}) do
    {:ok, %{
      "sub" => user["guid"],
      "given_name" => user["first_name"],
      "family_name" => user["last_name"],
      "email" => user["email"],
      "email_verified" => false # change to true to bypass need for verification
    }}
  end
end
