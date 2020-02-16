defmodule UserServiceWeb.Pow.SsoExtension do
  @moduledoc """
  Pow Extension to set an SSO cookie for the current user on login. This SSO cookie can be used
  by other domains under the same parent in order to provide server-server verified SSO session.
  """

  use Pow.Extension.Base

  @impl true
  def phoenix_controller_callbacks?(), do: true

  def cookie_name() do
    "sso_session"
  end

  def cookie_domain() do
    Application.get_env(:user_service, :sso_cookie_domain)
  end

  defmodule CleanupPlug do
    @moduledoc """
    Clear out the SSO cookie if there is no current user. This removes the cookie in case of normal
    logout, but also in the case of selectively deleting certain cookies.
    """

    import Plug.Conn

    alias UserServiceWeb.Pow.SsoExtension

    def init(_) do
      []
    end

    def call(conn, _opts) do
      case Pow.Plug.current_user(conn) do
        nil ->
          clear_sso_cookie(conn)

        _user ->
          conn
      end
    end

    defp clear_sso_cookie(conn) do
      case Map.get(conn.cookies, SsoExtension.cookie_name()) do
        nil ->
          conn

        sso_token ->
          IO.inspect "TODO: Cleanup #{sso_token}"
          Plug.Conn.delete_resp_cookie(conn, SsoExtension.cookie_name(), domain: SsoExtension.cookie_domain())
      end
    end
  end

  defmodule Phoenix.ControllerCallbacks do
    use Pow.Extension.Phoenix.ControllerCallbacks.Base

    alias UserServiceWeb.Pow.SsoExtension
    require Logger

    def before_respond(Pow.Phoenix.SessionController, :create, {:ok, conn}, _config) do
      case Pow.Plug.current_user(conn) do
        nil ->
          Logger.error("#{__MODULE__} create current_user=nil expected=not_nil")
          {:ok, conn}

        user ->
          {:ok, set_sso_cookie(conn)}
      end
    end

    defp set_sso_cookie(conn) do
      Plug.Conn.put_resp_cookie(conn, SsoExtension.cookie_name(), "TODO: create and insert token here", domain: SsoExtension.cookie_domain())
    end
  end
end
