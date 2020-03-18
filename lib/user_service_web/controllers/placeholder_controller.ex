defmodule UserServiceWeb.PlaceholderController do
  use UserServiceWeb, :controller

  plug Pow.Plug.RequireAuthenticated, error_handler: Pow.Phoenix.PlugErrorHandler

  def show(conn, _params) do
    render(conn, "show.html")
  end
end
