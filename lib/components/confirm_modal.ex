defmodule CrunchBerry.Components.ConfirmModal do
  @moduledoc """
  # ConfirmModal
  Reusable Cancel/Ok dialog box.  ConfimrmModal is a stateless component
  that takes a title and a message to display, and then sends a
  `confirm-ok` or `confirm-cancel` event to the hosting live view based on
  user selection.

  Required assigns
  * `title:` The title of the dialog box
  * `message:` The message to display.  Should describe an action that the user will confirm or cancel on

  Optional assigns
  * `call_to_action:` a prompt for action, defaults to "Are you sure you wish to proceed?"
  * `event_prefix:` a string to prefix the "ok" and "cancel" events, defaults to 'confirm', so the
    default events are "confirm-ok" and "confirm-cancel", but `:event_prefix` was set to "ask", then the events
    would be "ask-ok" and "ask-cancel"

  ## example:
  In the markup
  ```
  ...
    <%= if @reupload do %>
    <%= live_component CrunchBerry.Components.ConfirmModal,
      title: "Re-upload CSV",
      message: "This will clear the current session, and replace it with a new csv file." %>
    <% end %>
  ...
  ```

  In the live view:
  ```
  def handle_event("confirm-ok", _, socket) do
   ... do stuff, and don't say we didn't warn you
   {:noreply, assign(socket, reupload: false)}
  end

  def handle_event("confirm-cancel", _, socket) do
    {:noreply, assign(socket, reupload: false)}
  end
  ```
  """
  use Phoenix.HTML
  use Phoenix.LiveComponent

  @impl Phoenix.LiveComponent
  def update(assigns, socket) do
    event_prefix = Map.get(assigns, :event_prefix, "confirm")

    socket =
      assign(socket,
        title: assigns.title,
        message: assigns.message,
        call_to_action: Map.get(assigns, :call_to_action, "Are you sure you wish to proceed?"),
        cancel_event: "#{event_prefix}-cancel",
        ok_event: "#{event_prefix}-ok"
      )

    {:ok, socket}
  end

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div
      class="fixed inset-0 w-full h-full z-20 bg-black bg-opacity-50 overflow-y-auto flex items-center backdrop-filter backdrop-blur-sm"
      tabindex="-1"
      role="dialog"
      aria-modal="true"
      phx-capture-click="close"
      phx-window-keydown="close"
      phx-key="escape"
      phx-page-loading>
      <div class="relative mx-auto my-10 opacity-100 w-11/12 md:max-w-md rounded overflow-y-auto">
        <div class="relative bg-white shadow-lg rounded-md text-gray-900 z-20 flow-root">
          <div>
            <button phx-click={@cancel_event} aria_hidden="true" class="text-gray-400 text-2xl absolute top-0 right-0 py-1 px-3 rounded-full cursor-pointer hover:no-underline hover:text-black duration-50" title: "Close">&times;</button>
          </div>
          <div class="w-full max-w-lg p-2">
            <h2 class="font-bold block w-full text-center text-grey-darkest mb-2 pt-4"><%= @title %></h2>
            <div class="text-center">
              <%= @message %>
            </div>
            <div class="text-center">
              <%= @call_to_action %>
            </div>
            <div class="text-right p-2">
              <button phx-click={@cancel_event} class="bg-transparent hover:bg-blue-500 text-blue-700 font-semibold hover:text-white py-2 px-4 border border-blue-500 hover:border-transparent rounded">Cancel</button>
              <button phx-click={@ok_event} class="bg-transparent hover:bg-blue-500 text-blue-700 font-semibold hover:text-white py-2 px-4 border border-blue-500 hover:border-transparent rounded">Ok</button>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
