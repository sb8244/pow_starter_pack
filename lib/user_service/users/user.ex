defmodule UserService.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  use Pow.Extension.Ecto.Schema, extensions: [PowResetPassword, PowEmailConfirmation]

  import Ecto.Changeset

  schema "users" do
    field(:guid, Ecto.UUID, read_after_writes: true)
    field(:first_name, Ecto.TrimmedString)
    field(:last_name, Ecto.TrimmedString)

    pow_user_fields()

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
    |> cast(attrs, [:first_name, :last_name])
  end
end
