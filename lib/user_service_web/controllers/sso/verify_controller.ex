defmodule UserServiceWeb.Sso.VerifyController do
  @moduledoc """
  TODO: In production environment, this should be secured with an server-server secret. For starters, possibly just
        a list of secrets kept in config.
  """

  use UserServiceWeb, :controller

  def create(conn, %{"sso_token" => token}) do
    case UserService.Sso.get_user_for_sso_token(token) do
      {:ok, user} ->
        conn
        |> json(serialize(user))

      {:error, reason} ->
        conn
        |> put_status(422)
        |> json(%{error: "invalid_token", reason: reason})
    end
  end

  defp serialize(user) do
    %{
      email: user.email,
      guid: user.guid
    }
  end
end
