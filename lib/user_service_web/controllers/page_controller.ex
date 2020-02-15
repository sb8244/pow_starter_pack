defmodule UserServiceWeb.PageController do
  use UserServiceWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
