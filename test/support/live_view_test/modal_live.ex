defmodule CrunchBerry.LiveViewTest.ModalLive do
  @moduledoc false
  use Phoenix.LiveView

  defmodule ModalComponent do
    @moduledoc false
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

  import CrunchBerry.Components.LiveHelpers

  def mount(params, _, socket) do
    socket = assign(socket, :params, params)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div id="the_live_view">
      <div data-test-id="view-title">The LiveView</div>
      <%= if @params["show"] do %>
        <%= cond do %>
          <% @params["return_to"] -> %>
            <.live_modal component={ModalComponent} id="otter" return_to={@params["return_to"]} />
          <% @params["phx_target"] -> %>
            <.live_modal component={ModalComponent} id="otter" phx_target={@params["phx_target"]} />
          <% true -> %>
            <.live_modal component={ModalComponent} id="otter" />
        <% end %>
      <% end %>
      <%= if Map.has_key?(assigns, :message) do %>
        <div data-test-id="message">{@message}</div>
      <% end %>
    </div>
    """
  end

  def handle_event("close", _, socket) do
    params =
      socket.assigns.params
      |> Map.delete("show")

    socket =
      socket
      |> assign(:message, "wrapped modal got close event")
      |> assign(:params, params)

    {:noreply, socket}
  end

  def handle_params(params, _uri, socket) do
    {:noreply, assign(socket, :params, params)}
  end
end
