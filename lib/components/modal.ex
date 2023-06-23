defmodule CrunchBerry.Components.Modal do
  @moduledoc """
  Reusable modal component, for use with TailwindCSS
  """
  use Phoenix.HTML
  use Phoenix.LiveComponent

  @classes_defaults %{
    component:
      "fixed inset-0 w-full h-full z-20 bg-black bg-opacity-50 overflow-y-auto flex items-center backdrop-filter backdrop-blur-sm",
    container: "relative mx-auto my-10 opacity-100 w-11/12 md:max-w-md rounded overflow-y-auto",
    background: "relative bg-white shadow-lg rounded-md text-gray-900 z-20 flow-root",
    cancel_icon:
      "text-gray-400 text-2xl absolute top-0 right-0 py-1 px-3 rounded-full cursor-pointer hover:no-underline hover:text-black duration-50"
  }

  @impl Phoenix.LiveComponent
  def update(assigns, socket) do
    classes =
      assigns
      |> Map.get(:classes, %{})
      |> then(fn classes -> Map.merge(@classes_defaults, classes) end)

    socket =
      socket
      |> assign(assigns)
      |> assign(:classes, classes)

    {:ok, socket}
  end

  @impl Phoenix.LiveComponent
  def render(assigns) do
    phx_target_with_default = Map.get(assigns, :phx_target, "id")
    assigns = Map.put(assigns, :phx_target_with_default, phx_target_with_default)

    ~H"""
    <div
      id={@id}
      class={@classes[:component]}
      tabindex="-1"
      role="dialog"
      aria-labelledby={"#{@id}Label"}
      aria-modal="true"
      phx-capture-click="close"
      phx-window-keydown="close"
      phx-key="escape"
      phx-target={"##{@phx_target_with_default}"}
      phx-page-loading
    >
      <div class={@classes[:container]}>
        <div class={@classes[:background]}>
          <div>
            <%= if assigns[:return_to] do %>
              <%= live_patch(raw("&times;"),
                to: @return_to,
                aria_hidden: true,
                class: @classes[:cancel_icon],
                title: "Close"
              ) %>
            <% else %>
              <button
                type="button"
                aria-hidden="true"
                class={@classes[:cancel_icon]}
                title="Close"
                phx-click="close"
                phx-target={assigns[:phx_target] || false}
              >
                &times;
              </button>
            <% end %>
          </div>
          <.live_component id={"#{@id}-component"} module={@component} {@opts} />
        </div>
      </div>
    </div>
    """
  end

  @impl Phoenix.LiveComponent
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
