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
    plug UserServiceWeb.Plug.RedirectTo
    plug UserService.Sso.plug()
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug UserService.Sso.plug()
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
    pow_extension_routes()

    get "/login", Pow.Phoenix.SessionController, :new, as: :login
    get "/logout", Pow.Phoenix.SessionController, :delete, as: :logout
    get "/register", Pow.Phoenix.RegistrationController, :new, as: :register
  end

  scope "/", UserServiceWeb do
    pipe_through :browser

    get "/", PlaceholderController, :show
    get "/external_redirect", ExternalRedirectController, :show, as: :external_redirect
  end

  # Other scopes may use custom stacks.
  # scope "/api", UserServiceWeb do
  #   pipe_through :api
  # end
end
