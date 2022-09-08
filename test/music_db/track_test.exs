defmodule MusicDB.TrackTest do
  use ExUnit.Case, async: true

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MusicDB.Repo)
  end

  test "update track" do
    play_function = fn ->
      receive do
        :continue -> :ok
      end

      "So What"
      |> MusicDB.Track.by_title()
      |> MusicDB.Repo.one!()
      |> then(fn track ->
        MusicDB.Track.changeset(track, %{number_of_plays: track.number_of_plays + 1})
      end)
      |> then(fn changeset ->
        changeset |> MusicDB.Repo.update()
      end)
      |> then(fn {:ok, track} ->
        IO.inspect(track.number_of_plays)
      end)
    end

    tasks = [
      Task.start(fn -> play_function |> MusicDB.Repo.transaction() end),
      Task.start(fn -> play_function |> MusicDB.Repo.transaction() end),
      Task.start(fn -> play_function |> MusicDB.Repo.transaction() end),
      Task.start(fn -> play_function |> MusicDB.Repo.transaction() end),
      Task.start(fn -> play_function |> MusicDB.Repo.transaction() end)
    ]

    Enum.map(tasks, fn {:ok, task} ->
      Ecto.Adapters.SQL.Sandbox.allow(MusicDB.Repo, self(), task)
      send(task, :continue)
    end)

    Process.sleep(5_000)
    # number_of_plays에서 1이 나옵니다.
    assert MusicDB.Repo.get(MusicDB.Track, 1).number_of_plays == 5
  end
end
