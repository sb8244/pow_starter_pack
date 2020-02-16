defmodule UserService.Sso.Cookie do
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
end
