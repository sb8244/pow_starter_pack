defmodule UserService.Repo.Migrations.AddGuidToUsers do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION pgcrypto", "DROP EXTENSION pgcrypto"

    alter table(:users) do
      add :guid, :uuid, null: false, default: fragment("gen_random_uuid()")
    end

    create unique_index(:users, [:guid])
  end
end
