defmodule CrunchBerry.Components.LiveHelpers do
  @moduledoc """
  Helpers for LiveViews.
  """
  import Phoenix.LiveView.Helpers

  alias CrunchBerry.Components.Modal

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
end
