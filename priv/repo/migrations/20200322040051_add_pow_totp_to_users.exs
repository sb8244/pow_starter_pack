defmodule UserService.Repo.Migrations.AddPowTotpToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :totp_activated_at, :utc_datetime
      add :totp_secret, :string
    end
  end
end
