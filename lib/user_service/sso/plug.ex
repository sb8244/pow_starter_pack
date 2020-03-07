defmodule UserService.Sso.Plug do
  @moduledoc """
  Manages the SSO cookie lifecycle.

  Clear out the SSO cookie if there is no current user. This removes the cookie in case of normal
  logout, but also in the case of selectively deleting certain cookies.

  Sets the cookie with a valid SSO session if the user is logged in.
  """

  require Logger

  alias UserService.Sso.Cookie
  alias UserService.Sso.Store, as: SsoStore

  def init(_) do
    []
  end

  def call(conn, _opts) do
    conn =
      case conn.params["new_session"] do
        "true" ->
          clear_sso_session(conn)

        _ ->
          conn
      end

    case Pow.Plug.current_user(conn) do
      nil ->
        clear_sso_session(conn)

      user ->
        ensure_sso_session(conn, user: user)
    end
  end

  defp clear_sso_session(conn) do
    case Map.get(conn.cookies, Cookie.cookie_name()) do
      nil ->
        conn

      sso_token ->
        case Cookie.verify_session(sso_token) do
          {type, %{token: token}} when type in [:valid, :expired] ->
            SsoStore.delete_sso_token(token: token)

          {:invalid, e} ->
            Logger.error("#{__MODULE__}.clear_sso_session type=verify_session error=#{inspect(e)}")
        end

        Plug.Conn.delete_resp_cookie(conn, Cookie.cookie_name(), domain: Cookie.cookie_domain())
    end
  end

  defp ensure_sso_session(conn, user: user) do
    case Map.get(conn.cookies, Cookie.cookie_name()) do
      nil ->
        setup_sso_session(conn, user: user)

      token ->
        verify_sso_session(conn, token, user: user)
    end
  end

  @one_month 60 * 60 * 24 * 30

  defp setup_sso_session(conn, user: user) do
    sso_token = SsoStore.create_sso_token_for_user!(user)
    token = Cookie.sign_token(sso_token)
    Plug.Conn.put_resp_cookie(conn, Cookie.cookie_name(), token, domain: Cookie.cookie_domain(), max_age: @one_month)
  end

  defp verify_sso_session(conn, token, user: user) do
    case Cookie.verify_session(token) do
      {:valid, _} ->
        # Everything looks good, no changes needed
        conn

      {:expired, %{token: token}} ->
        SsoStore.delete_sso_token(token: token)
        setup_sso_session(conn, user: user)

      {:invalid, e} ->
        Logger.error("#{__MODULE__}.verify_sso_session type=verify_session error=#{inspect(e)}")
        conn
    end
  end
end
