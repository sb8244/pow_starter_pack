defmodule UserService.Users do
  import Ecto.Query

  alias UserService.Repo
  alias UserService.Users.{SsoToken}

  @one_month 60 * 60 * 24 * 30

  def create_sso_token_for_user!(_user = %{id: user_id}) when not is_nil(user_id) do
    expiry = (System.system_time(:second) + @one_month) |> DateTime.from_unix!()
    SsoToken.changeset(%{token: :random, expires_at: expiry, user_id: user_id})
    |> Repo.insert!()
  end

  def delete_sso_token(token: token) do
    from(sso in SsoToken, where: sso.token == ^token)
    |> Repo.delete_all
  end
end
