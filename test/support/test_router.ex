defmodule CrunchBerry.Router do
  @moduledoc """
  Router test harness for testing LiveViews
  """
  use Phoenix.Router
  import Phoenix.LiveView.Router

  pipeline :setup_session do
    plug Plug.Session,
      store: :cookie,
      key: "_live_view_key",
      signing_salt: "/VEDsdfsffMnp5"

    plug :fetch_session
  end

  pipeline :browser do
    plug :setup_session
    plug :accepts, ["html"]
    plug :fetch_live_flash
  end

  scope "/", CrunchBerry.LiveViewTest do
    pipe_through [:browser]

    # integration modal
    live("/modal", ModalLive)
  end
end
