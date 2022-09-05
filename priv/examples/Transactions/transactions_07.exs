
# 검색엔진과의 데이터 동기화 할때도 사용가능하다.
artist = %Artist{name: "Toshiko Akiyoshi"}
multi =
Multi.new()
  |> Multi.insert(:artist, artist)
  |> Multi.insert(:log, Log.changeset_for_insert(artist))
  |> Multi.run(:search, fn _repo, changes ->
    SearchEngine.update(changes[:artist])
  end)
Repo.transaction(multi)

# 더욱 간결하게 쓸수있다.
multi =
  Multi.new()
  |> Multi.insert(:artist, artist)
  |> Multi.insert(:log, Log.changeset_for_insert(artist))
  |> Multi.run(:search, SearchEngine, :update, ["extra argument"])
#=> [
#=>   artist: {:insert,
#=>   #Ecto.Changeset<action: :insert, changes: %{}, errors: [],
#=>   data: #MusicDB.Artist<>, valid?: true>, []},
#=>   log: {:insert,
#=>   #Ecto.Changeset<action: :insert, changes: %{}, errors: [],
#=>   data: #MusicDB.Log<>, valid?: true>, []},
#=>   search: {:run, {SearchEngine, :update, ["extra argument"]}}
#=> ]
