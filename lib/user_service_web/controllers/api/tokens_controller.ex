defmodule UserServiceWeb.Api.TokensController do
  use UserServiceWeb, :controller

  def new(conn, _params) do
    json(conn, payload(Pow.Plug.current_user(conn)))
  end

  defp payload(user) do
    %{
      now_utc: :erlang.system_time(:seconds),
      token: UserService.Access.user_access_token(user)
    }
  end
end
