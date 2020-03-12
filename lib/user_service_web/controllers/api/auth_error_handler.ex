defmodule UserServiceWeb.Api.AuthErrorHandler do
  use UserServiceWeb, :controller

  def call(conn, :not_authenticated) do
    conn
    |> put_status(401)
    |> json(%{error: "You must be signed in to access this"})
  end
end
