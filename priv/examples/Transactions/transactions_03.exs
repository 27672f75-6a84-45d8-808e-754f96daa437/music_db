# 외부 API와 함께 동기화되는 작업을해야할때
# Ecto는 검색엔진의 동작을 모르기 때문에 검색엔진의 변경점을 롤백할수없다.
# 따라서 우리가 수행해야할 데이터베이스 작업을 먼저 실행해주어야한다.

artist = %Artist{name: "Johnny Hodges"}
Repo.transaction(fn ->
  artist_record = Repo.insert!(artist)
  Repo.insert!(Log.changeset_for_insert(artist_record))
  SearchEngine.update!(artist_record)
end)
