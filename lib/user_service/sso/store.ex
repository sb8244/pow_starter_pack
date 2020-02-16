defmodule UserService.Sso.Store do
  @moduledoc """
  SSO cookie management for the current user on login. This SSO cookie can be used
  by other domains under the same parent in order to provide server-server verified SSO session.
  """

  import Ecto.Query

  alias UserService.Repo
  alias UserService.Sso.SsoToken

  @one_month 60 * 60 * 24 * 30

  def create_sso_token_for_user!(_user = %{id: user_id}) when not is_nil(user_id) do
    expiry = (System.system_time(:second) + @one_month) |> DateTime.from_unix!()
    SsoToken.changeset(%{token: :random, expires_at: expiry, user_id: user_id})
    |> Repo.insert!()
  end

  def delete_sso_token(token: token) do
    from(sso in SsoToken, where: sso.token == ^token)
    |> Repo.delete_all()
  end
end
