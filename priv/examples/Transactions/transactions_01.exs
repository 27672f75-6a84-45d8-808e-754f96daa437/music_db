# artist 데이터를 넣는것이 실패해도 로그는 남게된다.

artist = %Artist{name: "Jonny Hodges"}
Repo.insert(artist)
Repo.insert(Log.changeset_for_insert(artist))



# artist 데이터를 넣는것에 실패하면 error가 발생한다.
artist = %Artist{name: "Johnny Hodges"}
Repo.transaction(fn ->
  Repo.insert!(artist)
  Repo.insert!(Log.changeset_for_insert(artist))
end)
#=> {:ok, %MusicDB.Log{ ...}}

# artist 데이터를 넣는것에 실패하면 error가 발생한다.
artist = %Artist{name: "Ben Webster"}
Repo.transaction(fn ->
  Repo.insert!(artist)
  Repo.insert!(nil) # <-- this will fail
end)
#=> ** (FunctionClauseError) no function clause matching in
#=> Ecto.Repo.Schema.insert/4
