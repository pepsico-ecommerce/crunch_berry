defmodule CrunchBerry.Components.LiveHelpers do
  @moduledoc """
  Helpers for LiveViews.
  """
  import Phoenix.LiveView.Helpers

  alias CrunchBerry.Components.Modal
  alias CrunchBerry.Components.Pagination
  alias CrunchBerry.Components.TypeAhead

  @doc """
  Renders a component inside the `CrunchBerry.Components.Modal` component.

  ## Options

  - `id` - required.  The modal is a `Phoenix.LiveComponent`, and needs a specified `id`.
  - `return_to` - required.  This is the route that will be pushed to when the modal is closed,
  either by the "x" or clicking the background.

  ## Examples

      <%= live_modal MyProjectWeb.WidgetLive.FormComponent,
        id: :new,
        return_to: Routes.widget_index_path(@socket, :index)
        # Any option besides id/return_to is passed through to the child component,
        # this is where you can pass in any assigns the child component is going to need.
        action: @live_action
         %>
  """
  @spec live_modal(any(), keyword) ::
          Phoenix.LiveView.Component.t()
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(Modal, modal_opts)
  end

  @doc """
    Renders `CrunchBerry.Components.Pagination`.

    ## Options
    - `page` - required.  A [`Scrivener.Page`](https://github.com/drewolson/scrivener/blob/f0f5d544affd9b923f584cda66f077cdb6644f7a/lib/scrivener/page.ex) compatible data structure.
    - `name` - required.  Use for aria-labels
    - `classes` - overrides to customize the look and feel.  See classes below.

    ## Classes
    In order to customize the look and feel, you may pass in a map.  The following keys are supported:

    - active - Classes applied to the currently active page.
    - text - Classes applied to all children, except the currently active page.

    ## Pagination

    The containing LiveView/Component *must* implement the [`handle_event/3` callback](https://github.com/phoenixframework/phoenix_live_view/blob/v0.15.7/lib/phoenix_live_component.ex#L543).

    The callback is executed with a param of `%{"page" => page}` representing the user's selected page.

    Example:

    ```
    def handle_event("page", %{"page" => page}, socket) do
    {:noreply,
     push_redirect(socket,
       to: Routes.root_path(socket, :index, active_page: page)
     )}
    end
    ```

    ## Examples

      <%= live_pagination name: "My Cool Pagination",
      page: @page,
      classes: %{
        active: "bg-blue hover:bg-blue-900 text-white",
        text: "bg-white text-blue hover:bg-gray-100"
      }
       %>
  """
  @spec live_pagination(keyword()) :: Phoenix.LiveView.Component.t()
  def live_pagination(opts) do
    live_component(Pagination, opts)
  end

  @doc """
  Renders `CrunchBerry.Components.TypeAhead`.

  ## Options
  - `form` - required - the containing Phoenix.HTML.Form.
  - `label` - required - a form label for display purposes
  - `search_text` - required - this value will be used as the value for the input
  - `search_results` - required - a list of results from you typeahead search function the require type is `[{integer(), String.t()}]`
  - `current_focus` - required - a integer pointing to the index of the focused search_result, it shoud default to -1
  - `target` - required - an HTML selector that refers to the particular usage instance of the typeahead
  - `placeholder` - optional - You can optionally pass in placeholder text otherwise it defaults to "Searching..."

  ## Examples

    <%= live_type_ahead(form: f, label: "User Search", search_text: @search_text, search_results: @search_results,
                        current_focus: @current_focus, placeholder: "name or e-mail address...")  %>

  ## Internal Events
  - `type-ahead-blur` - optional - This `phx-blur` event can be used to clear te drop-down by setting `search_results` to `[]`
  - `type-ahead-set-focus` - optional - This `phx-window-keydown` event should haandle `%{"key" => "ArrowUp"}` and `%{"key" => "ArrowDown"}`
  to iceme a decrement `current_focus`.
  - `type-ahead-select` - optional - This `phx-click` handles clickig `search_results` in the drop-down
  it passes %{"type-ahead-result" => result_text, "type-ahead-result-id" => result_id, "value" => index_value}

  ## Other events
  The form that cotains the `live_type_ahead/1` call needs to imlment the following
  -`phx_change` to search for the text
  -`phx_submit` this will depend on the purpose of the form

  ## Handling Events

  The following are example event handlers you MIGHT implement. The list is not exhaustive,
  but should be helpful in getting started.

  ## Examples

    def mount(_params, _session, socket) do
      assigns = [
        search_text: "",
        search_results: [],
        current_focus: -1
      ]

      {:ok, assign(socket, assigns)}
    end

    def handle_event("type-ahead-blur", _, socket) do
      assigns = [search_results: [], current_focus: -1]
      {:noreply, assign(socket, assigns)}
    end

    # this is an example of a `phx_change` handler called "type-ahead-search"
    def handle_event("type-ahead-search", %{"type_ahead_search" => search}, socket) do
      results = YourContext.search_functon(search)
      assigns = [search_text: search, search_results: results]
      {:noreply, assign(socket(assigns))}
    end

    # "ArrowDown" is the is the inverse
    def handle_event("type-ahead-set-focus", %{"key" => "ArrowUp"}, socket) do
      current_focus = Enum.max([socket.assigns.current_focus - 1, 0])
      {:noreply, assign(socket, current_focus: current_focus)}
    end

    # on "Enter" this handler passes values to the submit event for the id
    # if  a particular element is choosen, otherwise the search text
    def handle_event("type-ahead-set-focus", %{"key" => "Enter"}, socket) do
      case Enum.at(socket.assigns.search_results, socket.assigns.current_focus) do
        {id, _} ->
          handle_event("YOUR-SUBMIT-EVENT", %{"id" => id}, socket)

        _ ->
          handle_event("YOUR-SUBMIT-EVENT", %{"type_ahead_search" => socket.assigns.search}, socket)
      end
    end

    def handle_event(
          "type-ahead-select",
          %{"type-ahead-result" => _, "type-ahead-result-id" => id, "value" => _},
          socket
        ) do
      {:noreply,
      push_patch(socket,
        to: Routes.some_path(socket, :SOME_ACTION, %{"id" => id}),
        replace: true
      )}
    end

    def handle_event("YOUR-SUBMIT-EVENT", %{"id" => id}, socket) do
      {:noreply,
      push_patch(socket,
        to: Routes.some_path(socket, :SOME_ACTION, %{"id" => id}),
        replace: true
      )}
    end

    def handle_event("YOUR-SUBMIT-EVENT", %{"type_ahead_search" => search}, socket) do
      params =
        if socket.assigns.current_focus == -1 do
          %{"type_ahead_search" => search}
        else
          socket.assigns.params
        end

      {:noreply,
      socket
      |> assign(:current_focus, -1)
      |> push_patch(
        to: Routes.some_path(socket, :SOME_ACTION, params),
        replace: true
      )}
    end
  """
  @spec live_type_ahead(keyword()) :: Phoenix.LiveView.Component.t()
  def live_type_ahead(opts) do
    live_component(TypeAhead, opts)
  end
end
