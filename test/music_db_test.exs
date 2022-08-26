defmodule MusicDBTest do
  use ExUnit.Case
  doctest MusicDB

  test "greets the world" do
    assert MusicDB.hello() == :world
  end
end
