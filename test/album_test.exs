defmodule MusicDB.AlbumTest do
  use ExUnit.Case, async: true

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MusicDB.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(MusicDB.Repo, {:shared, self()})
  end

  test "insert album" do
    task =
      Task.async(fn ->
        album = MusicDB.Repo.insert!(%MusicDB.Album{title: "Giant Steps"})
        album.id
      end)

    album_id = Task.await(task)
    assert MusicDB.Repo.get(MusicDB.Album, album_id).title == "Giant Steps"
  end
end
