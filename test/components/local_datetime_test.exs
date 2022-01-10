defmodule CrunchBerry.Components.LocalDateTimeTest do
  use CrunchBerry.ComponentCase

  import CrunchBerry.Components.LocalDateTime

  @timezone "America/Los_Angeles"
  @date ~N[2022-02-03 12:34:56]

  describe "local_datetime/1" do
    test "raises if required assigns aren't present" do
      assert_raise RuntimeError, ~r/`date` assign must be provided/, fn ->
        render_component(&local_datetime/1)
      end

      assert_raise RuntimeError, ~r/either `user` or `timezone` assign must be provided/, fn ->
        render_component(&local_datetime/1, date: @date)
      end
    end

    test "renders with default format" do
      assert render_component(&local_datetime/1, date: @date, timezone: @timezone) =~
               "<span>Feb 3, 22 4:34am</span>"
    end

    test "renders with custom format" do
      assert render_component(&local_datetime/1,
               date: @date,
               timezone: @timezone,
               format: "{YYYY}"
             ) =~
               "<span>2022</span>"
    end

    test "renders with timezone from user" do
      assert render_component(&local_datetime/1, date: @date, user: %{timezone: @timezone}) =~
               "<span>Feb 3, 22 4:34am</span>"
    end
  end

  describe "local_timezone/1" do
    test "raises if required assigns aren't present" do
      assert_raise RuntimeError, ~r/either `user` or `timezone` assign must be provided/, fn ->
        render_component(&local_timezone/1)
      end
    end

    test "renders timezone" do
      assert render_component(&local_timezone/1, timezone: @timezone) =~ @timezone
    end

    test "renders timezone from user" do
      assert render_component(&local_timezone/1, user: %{timezone: @timezone}) =~ @timezone
    end
  end
end
