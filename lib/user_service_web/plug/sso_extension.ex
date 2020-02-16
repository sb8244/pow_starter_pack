defmodule UserServiceWeb.Plug.SsoExtension do
  @moduledoc """
  SSO cookie management for the current user on login. This SSO cookie can be used
  by other domains under the same parent in order to provide server-server verified SSO session.
  """

  def cookie_name() do
    "sso_session"
  end

  def cookie_domain() do
    Application.get_env(:user_service, :sso_cookie_domain)
  end

  @one_month 60 * 60 * 24 * 30

  def sign_token() do
    secret = Application.get_env(:user_service, :sso_secret)
    expires_at = System.system_time(:second) + @one_month

    Phoenix.Token.sign(secret, "sso_salt", %{token: "TODO", expires_at: expires_at})
  end

  def verify_session(token) do
    secret = Application.get_env(:user_service, :sso_secret)
    now = System.system_time(:second)

    case Phoenix.Token.verify(secret, "sso_salt", token, max_age: :infinity) do
      {:ok, payload = %{expires_at: expire_at_s}} when expire_at_s > now ->
        {:valid, payload}

      {:ok, expired_payload} ->
        {:expired, expired_payload}

      {:error, e} ->
        {:invalid, e}
    end
  end

  defmodule SsoPlug do
    @moduledoc """
    Manages the SSO cookie lifecycle.

    Clear out the SSO cookie if there is no current user. This removes the cookie in case of normal
    logout, but also in the case of selectively deleting certain cookies.

    Sets the cookie with a valid SSO session if the user is logged in.
    """

    import Plug.Conn
    require Logger

    alias UserServiceWeb.Plug.SsoExtension

    def init(_) do
      []
    end

    def call(conn, _opts) do
      case Pow.Plug.current_user(conn) do
        nil ->
          clear_sso_cookie(conn)

        _user ->
          ensure_sso_session(conn)
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

    defp ensure_sso_session(conn) do
      case Map.get(conn.cookies, SsoExtension.cookie_name()) do
        nil ->
          setup_sso_session(conn)

        token ->
          # Is cookie still valid?
          verify_sso_session(conn, token)
      end
    end

    defp setup_sso_session(conn) do
      token = SsoExtension.sign_token()
      Plug.Conn.put_resp_cookie(conn, SsoExtension.cookie_name(), token, domain: SsoExtension.cookie_domain())
    end

    defp verify_sso_session(conn, token) do
      case SsoExtension.verify_session(token) do
        {:valid, _} ->
          conn

        {:expired, %{token: token}} ->
          IO.inspect "TODO: Delete the expired SSO entry"
          setup_sso_session(conn)

        {:invalid, e} ->
          Logger.error("#{__MODULE__} type=decrypting_token error=#{inspect e}")
          conn
      end
    end
  end
end
