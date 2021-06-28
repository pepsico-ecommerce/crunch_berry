defmodule CrunchBerry.Components.Modal do
  @moduledoc """
  Reusable modal component, for use with TailwindCSS
  """
  use Phoenix.HTML
  use Phoenix.LiveComponent

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~L"""
    <div
      id="<%= @id %>"
      class="fixed inset-0 w-full h-full z-20 bg-black bg-opacity-50 overflow-y-auto flex items-center backdrop-filter backdrop-blur-sm"
      tabindex="-1"
      role="dialog"
      aria-labelledby="<%= @id %>Label"
      aria-modal="true"
      phx-capture-click="close"
      phx-window-keydown="close"
      phx-key="escape"
      phx-target="#<%= @id %>"
      phx-page-loading>
        <div class="relative mx-auto my-10 opacity-100 w-11/12 md:max-w-md rounded overflow-y-auto">
          <div class="relative bg-white shadow-lg rounded-md text-gray-900 z-20 flow-root">
           <div>
             <%= live_patch raw("&times;"), to: @return_to, aria_hidden: true, class: "text-gray-400 text-2xl float-right py-1 px-3 rounded-full cursor-pointer hover:no-underline hover:text-black duration-50", title: "Close" %>
           </div>
           <%= live_component @socket, @component, @opts %>
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
