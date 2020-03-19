defmodule UserService.Repo.Migrations.CreateUserIdentities do
  use Ecto.Migration

  def change do
    create table(:user_identities) do
      add :provider, :string, null: false
      add :uid, :string, null: false
      add :user_id, :integer

      timestamps()
    end

    create unique_index(:user_identities, [:uid, :provider])
    create index(:user_identities, :user_id)
  end
end
