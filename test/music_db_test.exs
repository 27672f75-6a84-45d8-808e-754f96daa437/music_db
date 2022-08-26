defmodule MusicDbTest do
  use ExUnit.Case
  doctest MusicDb

  test "greets the world" do
    assert MusicDb.hello() == :world
  end
end
