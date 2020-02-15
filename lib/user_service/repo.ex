defmodule UserService.Repo do
  use Ecto.Repo,
    otp_app: :user_service,
    adapter: Ecto.Adapters.Postgres
end
