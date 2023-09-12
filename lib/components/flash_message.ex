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
  <.live_component id="my-component" module={StatelessComponentFixture} flash={@flash}/>`
  ```

  """
  import Phoenix.Component

  def render_flash(assigns) do
    ~H"""
    <%= render_flash_block(%{flash: @flash, myself: @myself, type: :error}) %>
    <%= render_flash_block(%{flash: @flash, myself: @myself, type: :info}) %>
    """
  end

  defp render_flash_block(%{type: type}) when type not in ~w(info error)a do
    raise "unrecognized flash type #{type}"
  end

  defp render_flash_block(assigns) do
    ~H"""
    <%= if message = live_flash(@flash, @type) do %>
      <div class={"pt-3 pb-1 px-4 #{bg_class(@type)}"}>
        <div class="flex">
          <div class="flex-shrink-0">
            <span class={"material-icons #{text_class(@type)}"}>
              <%= icon(@type) %>
            </span>
          </div>
          <div class="ml-2 mt-0.5">
            <p class={"text-sm font-medium #{text_class(@type)}"}>
              <%= message %>
            </p>
          </div>
          <div class="ml-auto pl-3">
            <div class="-my-1.5">
              <%= render_button(%{myself: @myself, type: @type}) %>
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
      <button
        type="button"
        phx-target={@myself}
        phx-value-key={@type}
        phx-click="lv:clear-flash"
        class={
          "text-2xl inline-flex px-1.5 pb-0.5 rounded-md focus:outline-none focus:ring-2 focus:ring-offset-2 #{button_class(@type)}"
        }
      >
        &times;
      </button>
      """
    else
      ~H"""
      <button
        type="button"
        phx-value-key={@type}
        phx-click="lv:clear-flash"
        class={
          "text-2xl inline-flex px-1.5 pb-0.5 rounded-md focus:outline-none focus:ring-2 focus:ring-offset-2 #{button_class(@type)}"
        }
      >
        &times;
      </button>
      """
    end
  end

  defp icon(:info), do: "check_circle"
  defp icon(:error), do: "error"

  # these `*_class` helpers should include the full class name without using string
  # interpolation, to play nicely with Tailwind JIT purging (make sure to include
  # `deps/crunch_berry/lib/components/*.ex` in your purge list)

  defp bg_class(:info), do: "bg-green-50"
  defp bg_class(:error), do: "bg-red-50"

  defp text_class(:info), do: "text-green-1"
  defp text_class(:error), do: "text-red-1"

  defp button_class(:info), do: "text-green-1 focus:ring-offset-green-50 focus:ring-green-1"
  defp button_class(:error), do: "text-red-1 focus:ring-offset-red-50 focus:ring-red-1"
end
