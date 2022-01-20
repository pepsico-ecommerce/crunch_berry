defmodule CrunchBerry.Components.LiveHelpersTest do
  use CrunchBerry.ComponentCase

  import CrunchBerry.Components.LiveHelpers
  import Phoenix.LiveViewTest

  describe "live_modal" do
    test "provides appropriate assigns" do
      %{assigns: assigns} =
        live_modal(ModalComponentFixture, id: :random_modal_id, return_to: "/mumble")

      assert assigns.component == ModalComponentFixture
      assert assigns.id == :random_modal_id
      assert assigns.return_to == "/mumble"
    end

    defmodule FixtureComponent do
      use Phoenix.LiveComponent

      def render(assigns) do
        ~H"""
        <p>Hello</p>
        """
      end
    end

    defmodule LiveViewFixture do
      use Phoenix.LiveView

      def render(assigns) do
        ~H"""
        <%= live_modal FixtureComponent,
        id: :random_modal_id,
        return_to: "/mumble" %>
        """
      end
    end

    test "renders with id and return_to", %{conn: conn} do
      {:ok, view, _html} = live_isolated(conn, LiveViewFixture)
      assert has_element?(view, "#random_modal_id")
      assert has_element?(view, ~s|a[href="/mumble"]|)
    end
  end
end
