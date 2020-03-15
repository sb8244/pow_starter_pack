defmodule UserServiceWeb.Api.TokensController do
  use UserServiceWeb, :controller

  def create(conn, _params) do
    json(conn, payload(Pow.Plug.current_user(conn)))
  end

  defp payload(user) do
    %{
      duration_in_seconds: UserService.Access.token_duration_in_seconds(),
      now_utc: :erlang.system_time(:seconds),
      subject: user.guid,
      token: UserService.Access.user_access_token(user)
    }
  end
end
