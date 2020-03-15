defmodule UserServiceWeb.Plug.FetchUserPlug do
  @moduledoc """
  Plug to refetch the current user from Pow, to ensure that it's always up to date.

  From: https://hexdocs.pm/pow/1.0.19/sync_user.html#content

  Motivation: Not every controller may need the most up-to-date user (it could be cached and used), but
              it's easier to assume an un-cached user and then cache if there's performance issues in the
              future.
  """

  @behaviour Plug

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    config = Pow.Plug.fetch_config(conn)

    case Pow.Plug.current_user(conn, config) do
      nil ->
        conn

      user ->
        reloaded_user = UserService.Users.get_user(user.id)
        Pow.Plug.assign_current_user(conn, reloaded_user, config)
    end
  end
end
