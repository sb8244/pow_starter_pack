defmodule UserConsumerWeb.Plug.SsoUserConsumer do
  require Logger
  import Plug.Conn

  @sso_base "http://idp.localhost.development:4000"
  @sso_url "#{@sso_base}/sso_api/verify"

  def sso_logout_url(opts \\ []) do
    next_url = Keyword.get(opts, :next_url, nil)

    query = URI.encode_query(%{redirect_to: next_url})
    "#{@sso_base}/logout?#{query}"
  end

  def init(_) do
    []
  end

  def call(conn, _opts) do
    with conn <- fetch_cookies(conn),
         {:token, sso_token} when not is_nil(sso_token) <- {:token, Map.get(conn.cookies, "sso_session")},
         {:request, {:ok, %{body: body}}} <- {:request, request_idp(sso_token)} |> IO.inspect,
         {:deserialize, {:ok, user = %{"guid" => _}}} <- {:deserialize, Phoenix.json_library().decode(body)} do
      IO.inspect(user)
      put_private(conn, :sso_user, user)
    else
      {:token, nil} ->
        sso_redirect(conn, new_cookie?: false)

      {:deserialize, {:ok, %{"error" => "invalid_token", "reason" => "invalid_session"}}} ->
        sso_redirect(conn, new_cookie?: true)

      {:request, err} ->
        Logger.error("#{__MODULE__} request error=#{inspect(err)}")
        conn

      {:deserialize, err} ->
        Logger.error("#{__MODULE__} deserialize error=#{inspect(err)}")
        conn
    end
  end

  defp sso_redirect(conn, new_cookie?: new_cookie?) do
    query = URI.encode_query(%{redirect_to: request_url(conn), new_session: new_cookie?})
    url = "#{@sso_base}/login?#{query}"
    redirect(conn, url)
    |> halt()
  end

  defp request_idp(sso_token) do
    body = URI.encode_query(%{"sso_token" => sso_token})
    Mojito.post(@sso_url, [{"content-type", "application/x-www-form-urlencoded"}], body)
  end

  def redirect(conn, url) do
    html = Plug.HTML.html_escape(url)
    body = "<html><body>You are being <a href=\"#{html}\">redirected</a>.</body></html>"

    conn
    |> put_resp_header("location", url)
    |> send_resp(302, body)
  end
end
