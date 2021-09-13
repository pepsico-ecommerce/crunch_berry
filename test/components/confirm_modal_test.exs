defmodule Optimizer.Api.UserLive.UploadSalesCSV.ConfirmModalTest do
  use ExUnit.Case
  import Phoenix.ConnTest
  alias CrunchBerry.Components.ConfirmModal
  import Phoenix.LiveViewTest

  @endpoint CrunchBerry.TestEndpoint

  setup do
    conn = build_conn()
    socket = %Phoenix.LiveView.Socket{}
    start_supervised!(CrunchBerry.TestEndpoint)
    {:ok, socket: socket, conn: conn}
  end

  describe "update" do
    test "defaults are set correctly", %{socket: socket} do
      requireds = %{
        title: "This is the title",
        message: "This event will happen"
      }

      assert {:ok, %{assigns: assigns}} = ConfirmModal.update(requireds, socket)

      assert %{
               call_to_action: "Are you sure you wish to proceed?",
               cancel_event: "confirm-cancel",
               message: "This event will happen",
               ok_event: "confirm-ok",
               title: "This is the title"
             } = assigns
    end

    test "can override event_prefix", %{socket: socket} do
      params = %{
        title: "This is the title",
        message: "This event will happen",
        event_prefix: "ask",
        call_to_action: "Do it?"
      }

      assert {:ok, %{assigns: assigns}} = ConfirmModal.update(params, socket)

      assert %{
               call_to_action: "Do it?",
               cancel_event: "ask-cancel",
               message: "This event will happen",
               ok_event: "ask-ok",
               title: "This is the title"
             } = assigns
    end
  end

  describe "render" do
    test "defaults render correctly", %{socket: socket} do
      requireds = %{
        title: "This is the title",
        message: "This event will happen"
      }

      {:ok, %{assigns: assigns}} = ConfirmModal.update(requireds, socket)

      result = render_component(ConfirmModal, assigns)

      assert result =~ "This is the title"
      assert result =~ "This event will happen"
      assert result =~ "phx-click=\"confirm-ok\""
      assert result =~ "phx-click=\"confirm-cancel\""
    end

    test "overrides render correctly" do
      requireds = %{
        title: "This is the title",
        message: "This event will happen",
        event_prefix: "ask",
        call_to_action: "Do it?"
      }

      result = render_component(ConfirmModal, requireds)

      assert result =~ "This is the title"
      assert result =~ "This event will happen"
      assert result =~ "phx-click=\"ask-ok\""
      assert result =~ "phx-click=\"ask-cancel\""
    end
  end

  defmodule LiveViewFixture do
    use Phoenix.LiveView

    def mount(_params, _session, socket) do
      {:ok, assign(socket, message: "None")}
    end

    def render(assigns) do
      ~H"""
      <%= live_component CrunchBerry.Components.ConfirmModal,
      title: "Re-upload CSV",
      message: "This will clear the current session, and replace it with a new csv file." %>
      <div>
      click: <%= @message %>
      </div>
      """
    end

    def handle_event(event, _params, socket) do
      {:noreply, assign(socket, message: event)}
    end
  end

  describe "events" do
    test "ok click", %{conn: conn} do
      {:ok, view, html} = live_isolated(conn, LiveViewFixture)
      assert html =~ "click: None"

      click_html =
        view
        |> element("button", "Ok")
        |> render_click()

      assert click_html =~ "click: confirm-ok"
    end

    test "cancel click, %", %{conn: conn} do
      {:ok, view, html} = live_isolated(conn, LiveViewFixture)
      assert html =~ "click: None"

      click_html =
        view
        |> element("button", "Cancel")
        |> render_click()

      assert click_html =~ "click: confirm-cancel"
    end
  end
end
