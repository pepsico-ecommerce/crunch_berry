defmodule CrunchBerryTestAppWeb.SalesLiveTest do
  use CrunchBerryTestAppWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "closing the modal" do
    test "with return_to defined, returns to return_to", %{conn: conn} do
      # The test liveview assigns all params to assigns, and displays
      # the modal based on "show". Initially show is true, but the return_to
      # path does not include a show.
      {:ok, view, html} = live(conn, "/sales?show=true&return_to=/sales")
      assert has_element?(view, "[data-test-id='view-title']", "The LiveView")
      assert html =~ "The Modal"

      html =
        view
        |> element("a", "×")
        |> render_click()

      refute html =~ "The Modal"
    end

    test "with return_to undefined, and a phx_target, delivers event to target", %{conn: conn} do
      {:ok, view, html} = live(conn, "/sales?show=true&phx_target=SalesLive")
      assert has_element?(view, "[data-test-id='view-title']", "The LiveView")
      assert html =~ "The Modal"

      html =
        view
        |> element("button", "×")
        |> render_click()

      refute html =~ "The Modal"
      assert html =~ "wrapped modal got close event"
    end

    test "with return_to and phx_target undefined, delivers event to the wrapped modal", %{
      conn: conn
    } do
      {:ok, view, html} = live(conn, "/sales?show=true")
      assert has_element?(view, "[data-test-id='view-title']", "The LiveView")
      assert html =~ "The Modal"

      html =
        view
        |> element("button", "×")
        |> render_click()

      refute html =~ "The Modal"
    end

    test "with return_to undefined, and a phx_target, handles key_down outside of modal", %{
      conn: conn
    } do
      {:ok, view, html} = live(conn, "/sales?show=true&phx_target=SalesLive")
      assert has_element?(view, "[data-test-id='view-title']", "The LiveView")
      assert html =~ "The Modal"

      html =
        view
        |> element("#modal")
        |> render_keydown()

      refute html =~ "The Modal"
    end
  end
end
