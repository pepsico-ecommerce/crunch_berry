defmodule CrunchBerry.Components.FlashMessageTest do
  use CrunchBerry.ComponentCase

  describe "Renders in a view" do
    defmodule LiveViewFixture do
      use Phoenix.LiveView
      import CrunchBerry.Components.LiveHelpers

      def mount(_params, _session, socket) do
        {:ok, socket}
      end

      def render(assigns) do
        ~H"""
        <div id="flash-content">
          <%= render_flash(assigns) %>
        </div>

        <button phx-click="push-me" phx-value="button">Click</button>
        """
      end

      def handle_event(event, _params, socket) do
        socket = Phoenix.LiveView.put_flash(socket, :info, "Info flash message")
        {:noreply, assign(socket, message: event)}
      end
    end

    test "Flash renders", %{conn: conn} do
      # Start out without a flash message
      {:ok, view, html} = live_isolated(conn, LiveViewFixture)
      refute html =~ "flash message"

      # click to create the flash message
      click_html =
        view
        |> element("button", "Click")
        |> render_click()

      # Verify that it is there
      assert click_html =~ "flash message"

      dismissed_html =
        view
        |> element("#flash-content button")
        |> render_click()

      refute dismissed_html =~ "flash message"
    end
  end

  defmodule ComponentFixture do
    use Phoenix.HTML
    use Phoenix.LiveComponent
    import CrunchBerry.Components.LiveHelpers

    def render(assigns) do
      ~H"""
      <div>
        <div id="flash-content">
          <%= render_flash(assigns) %>
        </div>

        <button phx-click="push-me" phx-value="button" phx-target={@myself}>Click</button>
      </div>
      """
    end

    def handle_event(event, _params, socket) do
      socket = Phoenix.LiveView.put_flash(socket, :info, "Info flash message")
      {:noreply, assign(socket, message: event)}
    end
  end

  describe "in a stateful component" do
    defmodule ComponentViewFixture do
      use Phoenix.LiveView

      def mount(_params, _session, socket) do
        {:ok, socket}
      end

      def render(assigns) do
        ~H"""
        <div>
          <.live_component module={ComponentFixture} id="test-fixture" />
        </div>
        """
      end

      def handle_event(event, _params, socket) do
        socket = Phoenix.LiveView.put_flash(socket, :info, "Info flash message")
        {:noreply, assign(socket, message: event)}
      end
    end

    test "renders correctly", %{conn: conn} do
      # Start out without a flash message
      {:ok, view, html} = live_isolated(conn, ComponentViewFixture)
      refute html =~ "flash message"

      # click to create the flash message
      click_html =
        view
        |> element("button", "Click")
        |> render_click()

      # Verify that it is there
      assert click_html =~ "flash message"

      dismissed_html =
        view
        |> element("#flash-content button")
        |> render_click()

      refute dismissed_html =~ "flash message"
    end
  end

  describe "in a stateless component" do
    defmodule StatelessComponentFixture do
      use Phoenix.HTML
      use Phoenix.LiveComponent
      import CrunchBerry.Components.LiveHelpers

      def render(assigns) do
        ~H"""
        <div>
          <div id="flash-content">
            <%= render_flash(assigns) %>
          </div>

          <button phx-click="push-me" phx-value="button">Click</button>
        </div>
        """
      end
    end

    defmodule ViewStatelessComponentFixture do
      use Phoenix.LiveView

      def mount(_params, _session, socket) do
        {:ok, socket}
      end

      def render(assigns) do
        ~H"""
        <div>
          <.live_component module={StatelessComponentFixture} id="flash-message" flash={@flash} />
        </div>
        """
      end

      def handle_event(event, _params, socket) do
        socket = Phoenix.LiveView.put_flash(socket, :error, "stateless flash error message")
        {:noreply, assign(socket, message: event)}
      end
    end

    test "renders correctly", %{conn: conn} do
      # Start out without a flash message
      {:ok, view, html} = live_isolated(conn, ViewStatelessComponentFixture)
      refute html =~ "stateless flash error message"

      # click to create the flash message
      click_html =
        view
        |> element("button", "Click")
        |> render_click()

      # Verify that it is there
      assert click_html =~ "stateless flash error message"

      dismissed_html =
        view
        |> element("#flash-content button")
        |> render_click()

      refute dismissed_html =~ "stateless flash error message"
    end
  end
end
