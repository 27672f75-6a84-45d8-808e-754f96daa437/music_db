defmodule MusicDB.AlbumTest do
  use ExUnit.Case

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MusicDB.Repo)
  end

  test "insert album" do
    task =
      Task.async(fn ->
        receive do
          :continue -> :ok
        end

        album = MusicDB.Repo.insert!(%MusicDB.Album{title: "Giant Steps"})
        album.id
      end)

    Ecto.Adapters.SQL.Sandbox.allow(MusicDB.Repo, self(), task.pid)
    send(task.pid, :continue)
    album_id = Task.await(task)
    assert MusicDB.Repo.get(MusicDB.Album, album_id).title == "Giant Steps"
  end

  test "update album" do
    task =
      Task.async(fn ->
        receive do
          :continue -> :ok
        end

        MusicDB.Repo.one!(MusicDB.Album.get_album_by_title("Kind Of Blue"))
        |> MusicDB.Album.changeset(%{title: "Kind of Red"})
        |> MusicDB.Repo.update!()
        |> then(fn album -> album.id end)
      end)

    Ecto.Adapters.SQL.Sandbox.allow(MusicDB.Repo, self(), task.pid)
    send(task.pid, :continue)
    album_id = Task.await(task)
    assert MusicDB.Repo.get(MusicDB.Album, album_id).title == "Kind of Red"
  end
end
