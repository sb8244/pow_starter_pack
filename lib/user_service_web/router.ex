defmodule UserServiceWeb.Router do
  use UserServiceWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router, extensions: [PowResetPassword, PowEmailConfirmation]
  use PowAssent.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug UserServiceWeb.Plug.RedirectTo
  end

  pipeline :skip_csrf_protection do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  pipeline :sso_api do
    plug :accepts, ["json"]
  end

  pipeline :api_protected do
    plug CORSPlug
    plug :accepts, ["json"]
    plug Pow.Plug.RequireAuthenticated, error_handler: UserServiceWeb.Api.AuthErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
    pow_extension_routes()
    pow_assent_routes()

    get "/login", Pow.Phoenix.SessionController, :new, as: :login
    get "/logout", Pow.Phoenix.SessionController, :delete, as: :logout
    get "/register", Pow.Phoenix.RegistrationController, :new, as: :register

    if Mix.env() == :dev do
      forward "/sent_emails", Bamboo.SentEmailViewerPlug
    end
  end

  scope "/" do
    pipe_through :skip_csrf_protection

    pow_assent_authorization_post_callback_routes()
  end

  scope "/", UserServiceWeb do
    pipe_through :browser

    get "/external_redirect", ExternalRedirectController, :show, as: :external_redirect
    get "/", PlaceholderController, :show
  end

  scope "/api", UserServiceWeb.Api do
    pipe_through :api_protected

    post "/tokens", TokensController, :create
  end

  scope "/sso_api", UserServiceWeb.Sso do
    pipe_through :sso_api

    post "/verify", VerifyController, :create
  end
end
