defmodule CrunchBerry.Components.TypeAhead do
  @moduledoc """
  Reusable modal component, for use with TailwindCSS
  """
  use Phoenix.HTML
  use Phoenix.LiveComponent

  @impl Phoenix.LiveComponent
  @type classes :: %{
          root: String.t(),
          container: String.t(),
          label: String.t(),
          input: String.t(),
          results_container: String.t(),
          results_list: String.t(),
          results_list_item: String.t(),
          results_focus: String.t()
        }
  @type args :: %{
          optional(:placeholder) => String.t(),
          form: Phoenix.HTML.Form.t(),
          label: String.t(),
          search_text: String.t(),
          search_results: [] | [{integer(), String.t()}],
          current_focus: integer(),
          target: %Phoenix.LiveComponent.CID{}
        }

  @classes_defaults %{
    root: "px-3 mb-6 md:mb-0",
    container: "relative w-full",
    label: "",
    input: "w-full",
    results_container: "absolute z-10 flex flex-col items-start w-full bg-white shadow-md mt-1",
    results_list: "flex flex-col w-full",
    results_list_item: "w-full px-2 py-3 cursor-pointer hover:bg-blue-3 hover:text-white",
    results_focus: "bg-blue-3 text-white outline-none"
  }
  @doc """
  The render function requires the form Struct, a search string, a target, and search_results. The placeholder
  key is optional and defaults to "Search...".
  """
  @spec render(args()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~L"""
    <div class="<%= class_or_default(assigns, :root) %>">
      <div class="<%= class_or_default(assigns, :container) %>" phx-debounce="blur">
        <%= label assigns.form, assigns.label, class: class_or_default(assigns, :label) %>
        <input class="<%= class_or_default(assigns, :input) %>" type="text" name="type_ahead_search" value="<%= assigns.search_text %>" phx-debounce="500" placeholder="<%= place_holder_or_default(assigns) %>" autocomplete="off" phx-blur="type-ahead-blur" <%= phx_target(assigns) %> />

        <%= if show_results?(assigns) do %>
          <%= do_render_drop_down(assigns) %>
        <% end %>
      </div>
    </div>
    """
  end

  defp do_render_drop_down(assigns) do
    ~L"""
    <div class="<%= class_or_default(assigns, :results_container) %>" role="menu">
      <ul class="<%= class_or_default(assigns, :results_list) %>" phx-window-keydown="type-ahead-set-focus" <%= phx_target(assigns) %>>
        <%= for {{id, result}, idx} <- Enum.with_index(assigns.search_results) do %>
          <li class="<%= class_or_default(assigns, :results_list_item) %> <%= if is_focus?(idx, assigns), do: class_or_default(assigns, :results_focus) %>"
              id = "<%= assigns.form.id%>_<%= id %>"
              phx-click="type-ahead-select"
              phx-value-type-ahead-result-id="<%= id %>"
              phx-value-type-ahead-result="<%= result %>"
              <%= phx_target(assigns) %>>
            <%= raw format_search_result(result, assigns.search_text) %>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end

  defp show_results?(%{search_results: res}), do: res != []

  defp is_focus?(idx, %{current_focus: focus}) do
    idx == focus
  end

  defp place_holder_or_default(%{placeholder: placeholder}), do: placeholder
  defp place_holder_or_default(_), do: "Search..."

  defp format_search_result(result, search_text) do
    search = Regex.escape(search_text)

    Regex.replace(~r/(#{search})/i, result, fn match, _ ->
      "<strong>#{match}</strong>"
    end)
  end

  defp phx_target(%{target: target}), do: "phx-target=#{target}"
  defp phx_target(_), do: nil

  defp class_or_default(%{classes: classes}, key) do
    Map.get(classes, key, Map.get(@classes_defaults, key))
  end

  defp class_or_default(_assigns, key), do: Map.get(@classes_defaults, key)
end
