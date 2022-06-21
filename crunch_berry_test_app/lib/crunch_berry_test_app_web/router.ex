defmodule CrunchBerryTestAppWeb.Router do
  use CrunchBerryTestAppWeb, :router
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CrunchBerryTestAppWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", CrunchBerryTestAppWeb do
    pipe_through :browser

    live "/sales", SalesLive, :show
  end
end
