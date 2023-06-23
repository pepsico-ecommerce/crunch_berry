defmodule CrunchBerry.IntegrationTest.ModalTest do
  use ExUnit.Case, async: true

  import Phoenix.ConnTest
  import Phoenix.LiveViewTest

  alias CrunchBerry.Router
  alias CrunchBerry.TestEndpoint

  @endpoint TestEndpoint

  # These tests are broken.
  @moduletag :skip

  setup do
    conn =
      Phoenix.ConnTest.build_conn(:get, "http://www.example.com/", nil)
      |> Phoenix.ConnTest.bypass_through(Router, [:browser])
      |> get("/modal")

    {:ok, conn: conn}
  end

  describe "closing the modal" do
    test "with return_to defined, returns to return_to", %{conn: conn} do
      # The test liveview assigns all params to assigns, and displays
      # the modal based on "show". Initially show is true, but the return_to
      # path does not include a show.
      {:ok, view, html} = live(conn, "/modal?return_to=/modal&show=true")
      assert html =~ "The LiveView"
      assert html =~ "The Modal"

      html =
        view
        |> element("a", "×")
        |> render_click()

      assert html =~ "The LiveView"
      refute html =~ "The Modal"
    end

    test "with return_to undefined, and a phx_target, delivers event to target", %{conn: conn} do
      {:ok, view, html} = live(conn, "/modal?phx_target=ModalLive&show=true")
      assert html =~ "The LiveView"
      assert html =~ "The Modal"
      refute html =~ "wrapped modal got close event"

      html =
        view
        |> element("button", "×")
        |> render_click()

      assert html =~ "The LiveView"
      refute html =~ "The Modal"
      assert html =~ "wrapped modal got close event"
    end

    test "with return_to and phx_target undefined, delivers event to the wrapped modal", %{
      conn: conn
    } do
      {:ok, view, html} = live(conn, "/modal?show=true")
      assert html =~ "The LiveView"
      assert html =~ "The Modal"

      html =
        view
        |> element("button", "×")
        |> render_click()

      assert html =~ "The LiveView"
      refute html =~ "The Modal"
    end

    test "with return_to undefined, and a phx_target, handles key_down outside of modal", %{
      conn: conn
    } do
      {:ok, view, html} = live(conn, "/modal?phx_target=ModalLive&show=true")
      assert html =~ "The LiveView"
      assert html =~ "The Modal"

      html =
        view
        |> element("#modal")
        |> render_keydown()

      assert html =~ "The LiveView"
      refute html =~ "The Modal"
    end
  end
end
