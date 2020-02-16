defmodule UserService.Repo.Migrations.CreateSsoTokens do
  use Ecto.Migration

  def change do
    create table(:sso_tokens) do
      add :token, :text, null: false
      add :expires_at, :utc_datetime_usec, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:sso_tokens, [:user_id])
    create unique_index(:sso_tokens, [:token])
  end
end
