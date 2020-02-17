defmodule UserServiceWeb.Plug.RedirectTo do
  import Plug.Conn

  def session_key(), do: :saved_redirect_to

  def init(_) do
    []
  end

  def call(conn = %{query_params: %{"redirect_to" => redirect_to}}, _opts) do
    put_session(conn, session_key(), validated_redirect_to(redirect_to))
  end

  def call(conn, _), do: conn

  defp validated_redirect_to(url) do
    uri = URI.parse(url)

    if uri.scheme && String.ends_with?(uri.host, cookie_domain()) do
      url
    else
      nil
    end
  end

  defp cookie_domain(), do: Application.get_env(:user_service, :sso_cookie_domain)
end
