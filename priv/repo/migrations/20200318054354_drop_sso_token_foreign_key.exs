defmodule UserService.Repo.Migrations.DropSsoTokenForeignKey do
  use Ecto.Migration

  def up do
    drop constraint("sso_tokens", "sso_tokens_user_id_fkey")
  end

  def down do
    alter table("sso_tokens") do
      modify :user_id, references(:users, on_delete: :nothing), null: false
    end
  end
end
