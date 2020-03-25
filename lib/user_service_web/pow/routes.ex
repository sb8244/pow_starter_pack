defmodule UserServiceWeb.Pow.Routes do
  use Pow.Phoenix.Routes

  alias UserServiceWeb.Router.Helpers, as: Routes
  alias UserServiceWeb.Plug.RedirectTo

  @impl true
  def user_not_authenticated_path(conn) do
    Routes.pow_session_path(conn, :new)
  end

  @impl true
  def after_sign_in_path(conn) do
    case external_url(conn) do
      nil ->
        "/"

      _ ->
        Routes.external_redirect_path(conn, :show)
    end
  end

  @impl true
  def after_sign_out_path(conn, routes_module \\ __MODULE__) do
    case external_url(conn) do
      nil ->
        routes_module.session_path(conn, :new)

      _ ->
        Routes.external_redirect_path(conn, :show)
    end
  end

  defp external_url(conn) do
    Plug.Conn.get_session(conn, RedirectTo.session_key())
  end
end
