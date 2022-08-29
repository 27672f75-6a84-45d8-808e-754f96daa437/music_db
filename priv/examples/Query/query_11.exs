
# 이대로 Repo.all 같은 디비에 접근하려고 하면 :select가 작성되지 않았다는 오류를 뿜어낸다
albums_by_miles = from a in "albums",
  join: ar in "artists", on: a.artist_id == ar.id,
  where: ar.name == "Miles Davis"

# 위의 쿼리문을 지금 완성
album_query = from a in albums_by_miles, select: a.title
  #=> #Ecto.Query<from a0 in "albums", join: a1 in "artists",
  #=> on: a0.artist_id == a1.id, where: a1.name == "Miles Davis",
  #=> select: a0.title>

  # 위에서 만든 albums_by_miles 쿼리로 track_query를 만들수있다.
  track_query = from a in albums_by_miles,
join: t in "tracks", on: a.id == t.album_id,
select: t.title

miles_tracks = Repo.all(track_query)

albums_by_miles = from a in "albums", as: :albums,
  join: ar in "artists", as: :artists,
  on: a.artist_id == ar.id, where: ar.name == "Miles Davis"

  # 스트링으로 이름을 바인딩하는것은 동작하지 않는다.
albums_by_miles = from a in "albums", as: "albums",
  join: ar in "artists", as: "artists",
  on: a.artist_id == ar.id, where: ar.name == "Miles Davis"

# 다른 쿼리에서 바인딩된 쿼리를 불러오려면 다음과 같이 작성한다.

album_query = from [albums: a] in albums_by_miles, select: a.title

# 바인딩한 쿼리를 가져와 다음과 같이도 사용가능하다.

album_query = from [artists: ar, albums: a] in albums_by_miles,
  select: [a.title, ar.name]
