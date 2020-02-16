# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :user_service,
  ecto_repos: [UserService.Repo],
  redis_uri: "redis://localhost:6379",
  redis_namespace: "user-service-#{Mix.env()}",
  sso_secret: "5JLgxF6lCAtgxc42e/Cg3lloPfnGicP1M1V6ZwQmnSmc5NIwzGs5X0ddF2mgP5f0Xl1nvi59sW8DcKovWXm0z8O3Bln82OAIgUM4"

config :user_service, :pow,
  cache_store_backend: UserServiceWeb.Pow.RedisCache,
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  extensions: [PowResetPassword, PowEmailConfirmation, PowPersistentSession],
  mailer_backend: UserServiceWeb.Pow.Mailer,
  repo: UserService.Repo,
  user: UserService.Users.User,
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
