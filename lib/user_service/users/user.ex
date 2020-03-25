defmodule UserService.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  use PowAssent.Ecto.Schema
  use Pow.Extension.Ecto.Schema, extensions: [PowResetPassword, PowEmailConfirmation, PowTotp]

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

  def user_identity_changeset(user_or_changeset, user_identity, attrs, user_id_attrs) do
    attrs = extract_name_attrs(attrs)

    user_or_changeset
    |> cast(attrs, [:first_name, :last_name])
    |> pow_assent_user_identity_changeset(user_identity, attrs, user_id_attrs)
  end

  defp extract_name_attrs(attrs = %{"given_name" => fname, "family_name" => lname}) do
    Map.merge(attrs, %{"first_name" => fname, "last_name" => lname})
  end

  defp extract_name_attrs(attrs = %{"name" => name}) do
    String.split(name, " ", parts: 2)
    |> case do
      [name] ->
        Map.put(attrs, "first_name", name)

      [fname, lname] ->
        Map.merge(attrs, %{"first_name" => fname, "last_name" => lname})
    end
  end

  defp extract_name_attrs(attrs), do: attrs
end
