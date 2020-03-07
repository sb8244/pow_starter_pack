defmodule UserService.Sso do
  @moduledoc """
  SSO cookie management for the current user on login. This SSO cookie can be used
  by other domains under the same parent in order to provide server-server verified SSO session.
  """

  alias __MODULE__.{Cookie, Plug, Store}

  def plug(), do: Plug

  def get_user_for_sso_token(sso_token) do
    with {:verify, {:valid, %{token: token}}} <- {:verify, Cookie.verify_session(sso_token)},
         {:find_token, %{user_id: id}} <- {:find_token, Store.find_valid_token(token)},
         {:find_user, user = %{}} <- {:find_user, UserService.Users.get_user(id)} do
      {:ok, user}
    else
      {:verify, {:invalid, _}} ->
        {:error, :invalid_session}

      {:verify, e} ->
        {:error, :verifying_session}

      {:find_token, _} ->
        {:error, :finding_token}

      {:find_user, _} ->
        {:error, :finding_user}
    end
  end
end
