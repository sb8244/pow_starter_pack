defmodule UserService.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      UserService.Repo,
      UserService.Redix,
      UserServiceWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: UserService.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    UserServiceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
