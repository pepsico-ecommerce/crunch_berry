defmodule CrunchBerryTestApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      CrunchBerryTestApp.Repo,
      # Start the Telemetry supervisor
      CrunchBerryTestAppWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: CrunchBerryTestApp.PubSub},
      # Start the Endpoint (http/https)
      CrunchBerryTestAppWeb.Endpoint
      # Start a worker by calling: CrunchBerryTestApp.Worker.start_link(arg)
      # {CrunchBerryTestApp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CrunchBerryTestApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CrunchBerryTestAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
