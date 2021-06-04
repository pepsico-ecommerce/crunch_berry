defmodule CrunchBerryTest do
  use ExUnit.Case
  doctest CrunchBerry

  test "greets the world" do
    assert CrunchBerry.hello() == :world
  end
end
