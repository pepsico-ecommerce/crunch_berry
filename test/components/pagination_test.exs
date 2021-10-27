defmodule CrunchBerry.Components.PaginationTest do
  use ExUnit.Case
  import Phoenix.ConnTest
  alias CrunchBerry.Components.Pagination
  import Phoenix.LiveViewTest

  @endpoint CrunchBerry.TestEndpoint

  setup do
    conn = build_conn()
    socket = %Phoenix.LiveView.Socket{}
    start_supervised!(CrunchBerry.TestEndpoint)
    {:ok, socket: socket, conn: conn}
  end

  describe "update" do
    test "assigns are set", %{socket: socket} do
      assigns = %{
        name: "Test name",
        page: %{
          page_number: 1,
          total_pages: 10
        }
      }

      assert {:ok, %{assigns: assigns}} = Pagination.update(assigns, socket)

      assert %{
               page: %{
                 page_number: 1,
                 total_pages: 10
               },
               name: "Test name",
               classes: %{},
               page_event_name: "page"
             } = assigns
    end
  end

  describe "render/1" do
    test "default renders correctly" do
      assigns = %{
        name: "unit-test",
        page: %{
          page_number: 1,
          total_pages: 10
        },
        classes: %{
          active: "active-class",
          text: "text-class"
        }
      }

      result = render_component(Pagination, assigns)
      assert result =~ ~s(phx-click="page")

      for idx <- 1..10 do
        assert result =~ ~s(phx-value-page="#{idx}")
      end

      assert result =~ "text-class"

      # assert that the first page is marked active
      assert [{"button", attributes, _}] =
               result |> Floki.parse_fragment!() |> Floki.find("button.active-class")

      assert Enum.any?(attributes, fn {name, value} ->
               name == "phx-value-page" && value == "1"
             end)

      assert [{"button", attributes, _}] =
               result
               |> Floki.parse_fragment!()
               |> Floki.find("button[aria-label='Next']")

      assert Enum.any?(attributes, fn {name, value} ->
               name == "phx-value-page" && value == "2"
             end)

      # Since we are on page 1, no previous button
      assert [] ==
               result
               |> Floki.parse_fragment!()
               |> Floki.find("button[aria-label='Previous']")
    end

    test "different page highlights different number" do
      assigns = %{
        name: "unit-test",
        page: %{
          page_number: 2,
          total_pages: 10
        },
        classes: %{
          active: "active-class",
          text: "text-class"
        }
      }

      result = render_component(Pagination, assigns)

      # assert that the first page is marked active
      assert [{"button", attributes, _}] =
               result
               |> Floki.parse_fragment!()
               |> Floki.find("button.active-class")

      assert Enum.any?(attributes, fn {name, value} ->
               name == "phx-value-page" && value == "2"
             end)

      assert [{"button", attributes, _}] =
               result
               |> Floki.parse_fragment!()
               |> Floki.find("button[aria-label='Next']")

      assert Enum.any?(attributes, fn {name, value} ->
               name == "phx-value-page" && value == "3"
             end)

      assert [{"button", attributes, _}] =
               result
               |> Floki.parse_fragment!()
               |> Floki.find("button[aria-label='Previous']")

      assert Enum.any?(attributes, fn {name, value} ->
               name == "phx-value-page" && value == "1"
             end)
    end

    test "last page" do
      assigns = %{
        name: "unit-test",
        page: %{
          page_number: 10,
          total_pages: 10
        },
        classes: %{
          active: "active-class",
          text: "text-class"
        }
      }

      result = render_component(Pagination, assigns)

      # assert that the first page is marked active
      assert [{"button", attributes, _}] =
               result
               |> Floki.parse_fragment!()
               |> Floki.find("button.active-class")

      assert Enum.any?(attributes, fn {name, value} ->
               name == "phx-value-page" && value == "10"
             end)

      # Last page, so no next button
      assert [] ==
               result
               |> Floki.parse_fragment!()
               |> Floki.find("button[aria-label='Next']")

      assert [{"button", attributes, _}] =
               result
               |> Floki.parse_fragment!()
               |> Floki.find("button[aria-label='Previous']")

      assert Enum.any?(attributes, fn {name, value} ->
               name == "phx-value-page" && value == "9"
             end)
    end
  end

  defmodule PaginationFixture do
    use Phoenix.LiveView

    def mount(_params, _session, socket) do
      {:ok, assign(socket, message: "None")}
    end

    def render(assigns) do
      ~H"""
      <%= live_component CrunchBerry.Components.Pagination, %{
        name: "unit-test",
        page: %{
          page_number: 1,
          total_pages: 10
        },
        classes: %{
          active: "active-class",
          text: "text-class"
        }
      }%>
      <div>
      click: <%= @message %>
      </div>
      """
    end

    def handle_event(event, %{"page" => page_num}, socket) do
      {:noreply, assign(socket, message: "#{event} #{page_num}")}
    end
  end

  describe "events" do
    test "page 2 event", %{conn: conn} do
      {:ok, view, html} = live_isolated(conn, PaginationFixture)
      assert html =~ "click: None"

      click_html =
        view
        |> element("button", "2")
        |> render_click()

      assert click_html =~ "click: page 2"
    end

    test "page 3 event, %", %{conn: conn} do
      {:ok, view, html} = live_isolated(conn, PaginationFixture)
      assert html =~ "click: None"

      click_html =
        view
        |> element("button", "3")
        |> render_click()

      assert click_html =~ "click: page 3"
    end
  end
end
