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

      _ ->
        conn
        |> put_status(422)
        |> json(%{error: "invalid token"})
    end
  end

  defp serialize(user) do
    %{
      id: user.id,
      email: user.email
    }
  end
end