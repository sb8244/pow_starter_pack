defmodule UserServiceWeb.PlaceholderController do
  use UserServiceWeb, :controller

  def show(conn, _params) do
    render(conn, "show.html")
  end
end
