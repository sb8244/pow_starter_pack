defmodule UserConsumerWeb.Router do
  use UserConsumerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug UserConsumerWeb.Plug.SsoUserConsumer
  end

  scope "/", UserConsumerWeb do
    pipe_through :api

    get "/", PlaceholderController, :show
  end
end
