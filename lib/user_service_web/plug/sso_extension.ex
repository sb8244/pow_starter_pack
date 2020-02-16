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

  def sign_token(%{token: token, expires_at: expires_at}) do
    secret = Application.get_env(:user_service, :sso_secret)

    Phoenix.Token.sign(secret, "sso_salt", %{token: token, expires_at: expires_at})
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

    require Logger

    alias UserServiceWeb.Plug.SsoExtension

    def init(_) do
      []
    end

    def call(conn, _opts) do
      case Pow.Plug.current_user(conn) do
        nil ->
          clear_sso_session(conn)

        user ->
          ensure_sso_session(conn, user: user)
      end
    end

    defp clear_sso_session(conn) do
      case Map.get(conn.cookies, SsoExtension.cookie_name()) do
        nil ->
          conn

        sso_token ->
          case SsoExtension.verify_session(sso_token) do
            {type, %{token: token}} when type in [:valid, :expired] ->
              UserService.Users.delete_sso_token(token: token)

            {:invalid, e} ->
              Logger.error("#{__MODULE__}.clear_sso_session type=verify_session error=#{inspect e}")
          end

          Plug.Conn.delete_resp_cookie(conn, SsoExtension.cookie_name(), domain: SsoExtension.cookie_domain())
      end
    end

    defp ensure_sso_session(conn, user: user) do
      case Map.get(conn.cookies, SsoExtension.cookie_name()) do
        nil ->
          setup_sso_session(conn, user: user)

        token ->
          verify_sso_session(conn, token, user: user)
      end
    end

    defp setup_sso_session(conn, user: user) do
      sso_token = UserService.Users.create_sso_token_for_user!(user)
      token = SsoExtension.sign_token(sso_token)
      Plug.Conn.put_resp_cookie(conn, SsoExtension.cookie_name(), token, domain: SsoExtension.cookie_domain())
    end

    defp verify_sso_session(conn, token, user: user) do
      case SsoExtension.verify_session(token) do
        {:valid, _} ->
          # Everything looks good, no changes needed
          conn

        {:expired, %{token: token}} ->
          UserService.Users.delete_sso_token(token: token)
          setup_sso_session(conn, user: user)

        {:invalid, e} ->
          Logger.error("#{__MODULE__}.verify_sso_session type=verify_session error=#{inspect e}")
          conn
      end
    end
  end
end
