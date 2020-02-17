defmodule UserServiceWeb.Pow.Routes do
  use Pow.Phoenix.Routes
  alias UserServiceWeb.Router.Helpers, as: Routes

  @impl true
  def user_not_authenticated_path(conn) do
    Routes.pow_session_path(conn, :new)
  end

  @impl true
  def after_sign_in_path(conn) do
    Routes.external_redirect_path(conn, :show)
  end
end
