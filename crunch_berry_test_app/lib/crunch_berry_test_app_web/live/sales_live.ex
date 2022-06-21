defmodule CrunchBerryTestAppWeb.SalesLive do
  use Phoenix.LiveView

  alias CrunchBerry.Components.LiveHelpers

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
          <% @params["return_to"] && @params["phx_target"] -> %>
            <% raise "return_to or phx_target, but not both" %>
          <% @params["return_to"] -> %>
            <%= LiveHelpers.live_modal(ModalComponent, id: "otter", return_to: @params["return_to"]) %>
          <% @params["phx_target"] -> %>
            <%= LiveHelpers.live_modal(ModalComponent, id: "otter", phx_target: @params["phx_target"]) %>
          <% true -> %>
            <%= LiveHelpers.live_modal(ModalComponent, id: "otter") %>
        <% end %>
      <% end %>
      <%= if Map.has_key?(assigns, :message) do %>
        <div data-test-id="message"><%= @message %></div>
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
