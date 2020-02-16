defmodule UserService.Users.SsoToken do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sso_tokens" do
    field :expires_at, :utc_datetime_usec
    field :token, :string
    field :user_id, :id

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(attrs) do
    attrs =
      if attrs[:token] == :random do
        length = 64
        token = :crypto.strong_rand_bytes(length) |> Base.encode64() |> binary_part(0, length)
        Map.put(attrs, :token, token)
      else
        attrs
      end

    %__MODULE__{}
    |> cast(attrs, [:token, :expires_at, :user_id])
    |> validate_required([:token, :expires_at, :user_id])
  end
end
