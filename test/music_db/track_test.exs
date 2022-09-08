defmodule MusicDB.TrackTest do
  use ExUnit.Case, async: true

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MusicDB.Repo)
  end

  test "update track" do
    parent = self()

    play_function = fn ->
      Ecto.Adapters.SQL.Sandbox.allow(MusicDB.Repo, parent, self())

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

    tasks =
      Enum.map(1..5, fn _ -> Task.async(fn -> play_function |> MusicDB.Repo.transaction() end) end)

    result = Task.await_many(tasks)

    IO.inspect(result)

    # Enum.map(tasks, fn {:ok, task} ->
    #
    #   send(task, :continue)
    # end)

    # Process.sleep(5_000)
    # # number_of_plays에서 1이 나옵니다.
    assert MusicDB.Repo.get(MusicDB.Track, 1).number_of_plays == 5
  end
end
