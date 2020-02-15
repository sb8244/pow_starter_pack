defmodule UserServiceWeb.Router do
  use UserServiceWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router, extensions: [PowResetPassword, PowEmailConfirmation]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
    pow_extension_routes()

    get "/login", Pow.Phoenix.SessionController, :new
    get "/logout", Pow.Phoenix.SessionController, :delete
    get "/register", Pow.Phoenix.RegistrationController, :new
  end

  scope "/", UserServiceWeb do
    pipe_through :browser

    get "/", PlaceholderController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", UserServiceWeb do
  #   pipe_through :api
  # end
end
