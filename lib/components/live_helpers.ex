defmodule CrunchBerry.Components.LiveHelpers do
  @moduledoc """
  Helpers for LiveViews.
  """
  import Phoenix.LiveView.Helpers
  import Phoenix.Component

  alias CrunchBerry.Components.FlashMessage
  alias CrunchBerry.Components.LocalDateTime
  alias CrunchBerry.Components.Modal
  alias CrunchBerry.Components.Pagination
  alias CrunchBerry.Components.TypeAhead

  @doc """
  Renders a component inside the `CrunchBerry.Components.Modal` component.

  ## Options

  - `id` - required.  The modal is a `Phoenix.LiveComponent`, and needs a specified `id`.
  - `return_to` - optional.  This is the route that will be pushed to when the modal is closed,
     either by the "x" or clicking the background. Either return_to or phx_target must be specified, or the close
     event will be routed to the parent live view.
  - `classes` - overrides to customize the look and feel.  See classes below.
  - `phx_target` - optional. If this value is specified, the component passed into phx_target must implement
     a function to handle the cancel event. This is used if the modal does not implement a return_to route,
     for instance if the modal is opened and closed via an assign.value versus a route.

  ## Classes
  In order to customize the look and feel, you may pass in a map.  The following keys are supported,
  from outer to inner:

  - component - Classes applied to the outermost component div, with id of @id. By default it is
    full width and height.
    default: fixed inset-0 w-full h-full z-20 bg-black bg-opacity-50 overflow-y-auto flex
             items-center backdrop-filter backdrop-blur-sm
  - container - Classes applied to the container that sets the width of the modal (11/12 with a max of
    max-w-md.
    default: relative mx-auto my-10 opacity-100 w-11/12 md:max-w-md rounded overflow-y-auto
  - background - Classes applied to the next container that sets the background color.
    default: relative bg-white shadow-lg rounded-md text-gray-900 z-20 flow-root
  - cancel_icon - Classes applied to the top right cancel icon (&times;)
    default: text-gray-400 text-2xl absolute top-0 right-0 py-1 px-3 rounded-full cursor-pointer
    hover:no-underline hover:text-black duration-50

  ## Examples

      <.live_modal
        component={MyProjectWeb.WidgetLive.FormComponent}
        id={:new}
        return_to={Routes.widget_index_path(@socket, :index)}
        classes={%{container: "relative mx-auto my-10 opacity-100 rounded overflow-x-auto"}}
        phx_target={@myself}
        # Any option besides id/return_to is passed through to the child component
        # this is where you can pass in any assigns the child component is going to need.
        action={@live_action}
      />
  """
  @spec live_modal(map) :: Phoenix.LiveView.Component.t()
  def live_modal(assigns) do
    assigns
    |> Map.merge(%{id: :modal, module: Modal, opts: assigns})
    |> live_component()
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
    - ellipsis - Classes applied to the "..." ellipsis page gap.
    - first - Classes applied to the first pagination button ("<<" (previous) or page number 1).
    - last - Classes applied to the last pagination button (">>" (next) or last page number).
    - list - Classes applied to the containing list.
    - next - Classes applied to the ">>" next button.
    - page - Classes applied to page buttons other than the "<<" previous and ">>" next buttons.
    - previous - Classes applied to the "<<" previous button.
    - text - Classes applied to all children, except the currently active page and the ellipsis page gap.

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

      <.live_pagination
        name="My Cool Pagination",
        page={@page}
        classes={%{
          active: "bg-blue hover:bg-blue-900 text-white",
          text: "bg-white text-blue hover:bg-gray-100"
        }}
      />
  """
  @spec live_pagination(map) :: Phoenix.LiveView.Component.t()
  def live_pagination(assigns) do
    assigns
    |> Map.merge(%{id: :pagination, module: Pagination})
    |> live_component()
  end

  @doc """
  Renders `CrunchBerry.Components.TypeAhead`.

  ## Options
  - `form` - required - the containing Phoenix.HTML.Form.
  - `label` - required - a form label for display purposes
  - `search_text` - required - this value will be used as the value for the input
  - `search_results` - required - a list of results from you typeahead search function the require type is `[{integer(), String.t()}]`
  - `current_focus` - required - a integer pointing to the index of the focused search_result, it shoud default to -1
  - `target` - optional - an HTML selector that refers to the particular usage instance of the typeahead
  - `placeholder` - optional - You can optionally pass in placeholder text otherwise it defaults to "Searching..."

  ## Examples

    <%= live_type_ahead(form: f, label: "User Search", search_text: @search_text, search_results: @search_results,
                        current_focus: @current_focus, placeholder: "name or e-mail address...")  %>

  ## Internal Events
  - `type-ahead-click-away` - optional - This `phx-click-away` event can be used to clear te drop-down by setting `search_results` to `[]`
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

  ## Styling

  When integrating TypeAhead into your application, you might find it useful to modify the styles.
  You can optionally provide a `classes` map, and apply styling to the following keys:
  - `root` - styles applied to the root element
  - `container` - styles applied to the dropdown/results container
  - `label` - styles applied to the label for the input
  - `input` - styles applied to the input
  - `results_container` - styles applied to the container for list items
  - `results_list` - styles applied to the `ul` containing the result items
  - `results_list_item` - styles applied to the `li`'s inside of the results list
  - `results_focus` - style applied to the currently active focus item
  """
  @spec live_type_ahead(keyword()) :: Phoenix.LiveView.Component.t()
  def live_type_ahead(opts) do
    live_component(TypeAhead, opts)
  end

  @doc """
  Renders markup to display flash messages from `put_live_flash/3`

  Assigns:
  This function must be called in a particular way every time:
  Inside of a stateful component -
  ```
  <%= render_flash(assigns) %>
  ```

  ## N.B. Using in a stateless component
  Note well, in order for change tracking to work in a stateless component,
  you must pass the flash into the assigns.  See the test `describe "in a stateless component" do`
  for a full example, but in a nutshell:
  If StateslessComponentFixture is using the `render_flash/1` then you need to pass in flash to the
  component for change tracking to work
  ```
  <.live_component id="my-component" module={StatelessComponentFixture} flash={@flash} />
  ```

  """
  @spec render_flash(any) :: Phoenix.LiveView.Rendered.t()
  def render_flash(assigns) do
    case assigns do
      # When called inside of a stateless component
      %{flash: _flash, myself: _myself} ->
        FlashMessage.render_flash(assigns)

      # Handle the case when called outside of a stateful component
      %{flash: _flash} ->
        assigns = Map.put(assigns, :myself, nil)
        FlashMessage.render_flash(assigns)
    end
  end

  defdelegate local_datetime(assigns), to: LocalDateTime
  defdelegate local_timezone(assigns), to: LocalDateTime
end
