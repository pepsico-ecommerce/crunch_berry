defmodule CrunchBerry.Components.LiveHelpers do
  @moduledoc """
  Helpers for LiveViews.
  """
  import Phoenix.LiveView.Helpers

  alias CrunchBerry.Components.Modal
  alias CrunchBerry.Components.Pagination

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
end
