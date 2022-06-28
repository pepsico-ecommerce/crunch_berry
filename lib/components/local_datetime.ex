defmodule CrunchBerry.Components.LocalDateTime do
  @moduledoc """
  Render a UTC `NaiveDateTime` in a user's local timezone using the given format
  (default: "Jan 1, 22 1:23pm"). `nil` datetimes will be rendered as `--`.

  ## Assigns

  - `date` naive datetime (required)
  - `user` user record containing a timezone
  - `timezone` ISO 8601 timezone (e.g. `America/New_York`)
  - `format` datetime format (uses `Timex.Format.DateTime.Formatters.Default`)
    (default: `"{Mshort} {D}, {YY} {h12}:{m}{am}"`)

  Either `user` or `timezone` must be provided.

  ## Usage

      <.local_datetime date={@date} timezone="America/Los_Angeles" />

      <.local_datetime date={@date} user={@user} />

  """

  use Phoenix.Component

  alias Timex.Timezone

  @default_format "{Mshort} {D}, {YY} {h12}:{m}{am}"

  @spec local_datetime(map()) :: any()
  def local_datetime(assigns) when not is_map_key(assigns, :date) do
    raise "`date` assign must be provided"
  end

  def local_datetime(assigns) do
    ~H"""
    <span><%= format(assigns) %></span>
    """
  end

  @doc """
  Display the local timezone.

  ## Usage

      <.local_timezone timezone="America/Los_Angeles" />

      <.local_timezone user={@user} />

  """
  @spec local_timezone(map()) :: any()
  def local_timezone(assigns) do
    ~H"""
    <span class="text-xs text-gray-cool-2 opacity-50 hover:opacity-100 transition-opacity cursor-default">
      timezone
      <code>
        <%= timezone(assigns) %>
      </code>
    </span>
    """
  end

  # ~~~ Helpers ~~~

  defp format(%{date: nil}), do: "--"

  defp format(%{date: date} = assigns) do
    # in order for a NaiveDateTime to be treated as UTC, it must first be explicitly
    # converted to "Etc/UTC" (see https://github.com/bitwalker/timex/issues/665#issuecomment-891336790)
    date
    |> Timezone.convert("Etc/UTC")
    |> Timezone.convert(timezone(assigns))
    |> Timex.format!(assigns[:format] || @default_format)
  end

  defp timezone(%{user: %{timezone: tz}}) when is_binary(tz), do: tz
  defp timezone(%{timezone: tz}) when is_binary(tz), do: tz

  defp timezone(_) do
    raise "either `user` or `timezone` assign must be provided"
  end
end
