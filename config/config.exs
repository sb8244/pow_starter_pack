# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :user_service,
  ecto_repos: [UserService.Repo]

config :user_service, :pow,
  user: UserService.Users.User,
  repo: UserService.Repo,
  web_module: UserServiceWeb

# Configures the endpoint
config :user_service, UserServiceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1gFAHb0Z8SHK5afTHBYoSeg++nByjZCTGiGTxFAsZeGCTAYVIHVhXVGRZTW29cta",
  render_errors: [view: UserServiceWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: UserService.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "Da+AaQgF"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
