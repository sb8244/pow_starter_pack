defmodule UserServiceWeb.ExternalRedirectController do
  use UserServiceWeb, :controller

  alias UserServiceWeb.Plug.RedirectTo

  def show(conn, _params) do
    case external_url(conn) do
      nil ->
        redirect(conn, to: "/")

      url ->
        conn
        |> clear_url()
        |> redirect(external: url)
    end
  end

  defp external_url(conn) do
    get_session(conn, RedirectTo.session_key())
  end

  defp clear_url(conn) do
    delete_session(conn, RedirectTo.session_key())
  end
end
