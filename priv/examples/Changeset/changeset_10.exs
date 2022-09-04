#### 이미 존재하는 데이터를 관계 맺으려고할 때

# Aritst과 관계된 앨범목록을 불러오지 못했다고 에러가 나온다.

changeset = Repo.get_by(Artist, name: "Miles Davis")
  |> change
  |> put_assoc(:albums, [%Album{title: "Miles Ahead"}])
Repo.update(changeset)
#=> ** (RuntimeError) attempting to cast or change association `albums`
#=> from `MusicDB.Artist` that was not loaded. Please preload your
#=> associations before manipulating them through changesets

# Aritst와 관계된 앨범을 불러왔음에도 여전히 값을 넣지 못하고있다.

changeset = Repo.get_by(Artist, name: "Miles Davis")
  |> Repo.preload(:albums)
  |> change
  |> put_assoc(:albums, [%Album{title: "Miles Ahead"}])
Repo.update(changeset)
#=> ** (RuntimeError) you are attempting to change relation :albums of
#=> MusicDB.Artist but the `:on_replace` option of
#=> this relation is set to `:raise`.
#=> ...


# 아래와 같이 기존 앨범을 더한 새로운 앨범 레코드를 넣어서 업데이트 가능하다.
# 하지만 새로운 앨범 하나를 기존에 있던 앨범에 관계를 추가하는것이므로 build_assoc이 더 적절하다.

artist =
  Repo.get_by(Artist, name: "Miles Davis")
  |> Repo.preload(:albums)

artist
  |> change
  |> put_assoc(:albums, [%Album{title: "Miles Ahead"} | artist.albums])
  |> Repo.update
