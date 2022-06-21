defmodule CrunchBerryTestApp.Repo do
  use Ecto.Repo,
    otp_app: :crunch_berry_test_app,
    adapter: Ecto.Adapters.Postgres
end
