defmodule CrunchBerry.Components.Pagination do
  @moduledoc """
  Pagination component for Live View.

  This component is designed to work with [Scrivener](https://github.com/drewolson/scrivener) result pages,
  using Tailwind classes.
  """
  use Phoenix.HTML
  use Phoenix.LiveComponent

  @type classes :: %{
          active: String.t(),
          ellipsis: String.t(),
          first: String.t(),
          last: String.t(),
          list: String.t(),
          next: String.t(),
          page: String.t(),
          previous: String.t(),
          text: String.t()
        }

  @first "rounded-l"
  @last "rounded-r"
  @button "block border-1 -ml-px px-3 py-2"

  @classes_defaults %{
    active: "",
    ellipsis: "block -ml-px px-3 pt-4",
    first: @first,
    last: @last,
    list: "flex rounded",
    next: "#{@last} #{@button}",
    page: @button,
    previous: "#{@first} #{@button}",
    text: ""
  }

  @impl Phoenix.LiveComponent
  def update(assigns, socket) do
    classes =
      assigns
      |> Map.get(:classes, %{})
      |> then(fn classes -> Map.merge(@classes_defaults, classes) end)

    socket =
      assign(socket,
        name: assigns.name,
        page: assigns.page,
        classes: classes,
        page_event_name: Map.get(assigns, :page_event_name, "page")
      )

    {:ok, socket}
  end

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <%= unless @page.total_pages == 1 do %>
    <nav aria-label={@name}>
      <ul class={@classes[:list]}>
        <%= if @page.page_number > 1 do %>
          <li>
            <button
              class={"#{@classes[:previous]} #{@classes[:text]}"}
              aria-label="Previous"
              phx-click={@page_event_name}
              phx-value-page={@page.page_number - 1}>
                <span aria-hidden="true">&laquo;</span>
                <span class="sr-only">Previous</span>
            </button>
          </li>
        <% end %>
        <%= for page_num <- page_numbers(@page.page_number, @page.total_pages) do %>
          <li>
            <%= if page_num == "..." do %>
              <span class={@classes[:ellipsis]}>
                <%= page_num %>
              </span>
            <% else %>
              <button
                class={"#{round_ends(page_num, @page.page_number, @page.total_pages)} #{maybe_active(page_num, @page.page_number, @classes)} #{@classes[:page]}"}
                phx-click={@page_event_name}
                phx-value-page={page_num}>
                <%= page_num %>
              </button>
            <% end %>
          </li>
        <% end %>
      <%= if @page.page_number < @page.total_pages do %>
        <li>
        <button
          class={"#{@classes[:next]} #{@classes[:text]}"}
          aria-label="Next"
          phx-click={@page_event_name}
          phx-value-page={@page.page_number + 1}>
            <span aria-hidden="true">&raquo;</span>
            <span class="sr-only">Next</span>
        </button>
        </li>
      <% end %>
      </ul>
    </nav>
    <% end %>
    """
  end

  defp page_numbers(_current_page, total_pages) when total_pages < 10 do
    Enum.to_list(1..total_pages)
  end

  defp page_numbers(current_page, total_pages) when current_page <= 9 do
    1..10
    |> Enum.to_list()
    |> Enum.concat(["...", total_pages])
  end

  defp page_numbers(current_page, total_pages) when total_pages - current_page < 10 do
    (total_pages - 10)..total_pages
    |> Enum.to_list()
    |> prepend_first_page
  end

  defp page_numbers(current_page, total_pages) do
    (current_page - 5)..(current_page + 4)
    |> Enum.to_list()
    |> Enum.concat(["...", total_pages])
    |> prepend_first_page
  end

  defp prepend_first_page(page_numbers) do
    [1, "..." | page_numbers]
  end

  defp maybe_active(current_page, current_page, classes), do: classes[:active]
  defp maybe_active(_page_num_item, _current_page_num, classes), do: classes[:text]

  defp round_ends(page_index, current_page_number, total_pages) do
    round_leading(page_index, current_page_number) <>
      " " <>
      round_trailing(page_index, current_page_number, total_pages)
  end

  defp round_leading(1 = _page_index, 1 = _current_page_number), do: @first
  defp round_leading(_, _), do: ""

  defp round_trailing(last_page, last_page, last_page), do: @last
  defp round_trailing(_, _, _), do: ""
end
