defmodule UserService.Repo.Migrations.AddNameToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :first_name, :text, null: false, default: ""
      add :last_name, :text, null: false, default: ""
    end
  end
end
