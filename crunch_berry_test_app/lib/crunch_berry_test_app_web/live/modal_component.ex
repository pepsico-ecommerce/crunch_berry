defmodule ModalComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div id="the_modal">
      <div data-test-id="modal-title">The Modal</div>
    </div>
    """
  end

  def handle_event("close", _params, socket) do
    params =
      socket.assigns.params
      |> Map.delete("show")

    socket = assign(socket, :params, params)
    {:noreply, socket}
  end
end
