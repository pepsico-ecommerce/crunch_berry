defmodule CrunchBerry.Components.FlashMessage do
  @moduledoc """
  Function to render flash message blocks in a consistent manner

  Uses layout for flash messages that was established in ecom_api, and makes
  it available to inject into components and layouts

  Flash messages are local to a component, so we can't package this up as a
  live_view component, because then the component would only display flash messages for itself.

  The assigns in the argument are *mandatory*

  e.g.
  ```
  <%= CrunchBerry.Components.FlashMessage.render_flash(%{flash: @flash, myself: @myself}) %>
  ```

  Or, if you are using the live_helper
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
  <%= live_component StatelessComponentFixture, flash: @flash %>`
  ```

  """
  import Phoenix.LiveView.Helpers

  def render_flash(assigns) do
    ~H"""
    <%= render_flash_block(%{flash: @flash, myself: @myself, color: "red", type: :error}) %>
    <%= render_flash_block(%{flash: @flash, myself: @myself, color: "green", type: :info}) %>
    """
  end

  defp render_flash_block(assigns) do
    ~H"""
    <%= if live_flash(@flash, @type) do %>
    <div class={"bg-true-#{@color}-50 pt-3 pb-1 px-4"}>
    <div class="flex">
    <div class="flex-shrink-0">
        <span class={"material-icons text-#{@color}-1"}>check_circle</span>
    </div>
    <div class="ml-2 mt-0.5">
        <p class={"text-sm font-medium text-#{@color}-1"}>
        <%= live_flash(@flash, @type) %>
        </p>
    </div>
    <div class="ml-auto pl-3">
        <div class="-my-1.5">
          <%= render_button(%{color: @color, myself: @myself, type: @type}) %>
        </div>
    </div>
    </div>
    </div>
    <% end %>
    """
  end

  defp render_button(assigns) do
    if Map.get(assigns, :myself) do
      ~H"""
      <button type="button" phx-click="lv:clear-flash" phx-value-key={@type} phx-target={@myself}
      class={"text-2xl inline-flex px-1.5 pb-0.5 rounded-md text-#{@color}-1 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-#{@color}-50 focus:ring-#{@color}-1"}>
        &times;
      </button>
      """
    else
      ~H"""
      <button type="button" phx-click="lv:clear-flash" phx-value-key={@type}
      class={"text-2xl inline-flex px-1.5 pb-0.5 rounded-md text-#{@color}-1 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-#{@color}-50 focus:ring-#{@color}-1"}>
        &times;
      </button>
      """
    end
  end
end
