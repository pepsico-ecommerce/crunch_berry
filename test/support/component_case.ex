defmodule CrunchBerry.ComponentCase do
  @moduledoc false
  use ExUnit.CaseTemplate

  using do
    quote do
      import Phoenix.ConnTest
      import Phoenix.LiveViewTest

      @endpoint CrunchBerry.TestEndpoint

      setup do
        conn = build_conn()
        socket = %Phoenix.LiveView.Socket{}

        start_supervised!(CrunchBerry.TestEndpoint)

        {:ok, socket: socket, conn: conn}
      end

      # default to empty list of assigns
      defp render_component(component), do: render_component(component, [])
    end
  end
end
