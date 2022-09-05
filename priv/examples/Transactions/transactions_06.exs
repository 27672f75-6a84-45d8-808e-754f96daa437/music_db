# 멀티는 실패시 다음을 반환한다.
# {:error, 실패한것에 대한 atom , changeset, _changes (변경 되었지만 데이터베이스에서 롤백 당한)}

artist = Repo.get_by(Artist, name: "Johnny Hodges")
artist_changeset = Artist.changeset(artist,
  %{name: "John Cornelius Hodges"})
invalid_changeset = Artist.changeset(%Artist{},
  %{name: nil})
multi =
  Multi.new
  |> Multi.update(:artist, artist_changeset)
  |> Multi.insert(:invalid, invalid_changeset)
Repo.transaction(multi)
#=> {:error, :invalid,
#=> #Ecto.Changeset<
#=>   action: :insert,
#=>   changes: %{},
#=>   errors: [name: {"can't be blank", [validation: :required]}],
#=>   data: #MusicDB.Artist<>,
#=>   valid?: false
#=> >, %{}}

# 아래와 같은 패턴매칭으로 에러를 처리할수있다.
case Repo.transaction(multi) do
  {:ok, _results} ->
    IO.puts "Operations were successful."
  {:error, :artist, changeset, _changes} ->
    IO.puts "Artist update failed"
    IO.inspect changeset.errors
  {:error, :invalid, changeset, _changes} ->
    IO.puts "Invalid operation failed"
    IO.inspect changeset.errors
end

# 앞선 예제에서는 데이터베이스에 도달하지 못했다 왜냐하면 데이터베이스에 도달하기전 :invalid에서 changeset 검증이 실패했기 때문이다.
# 하지만 이번 예제에서는 장르의 이름으로 데이터를 넣는데 장르는 데이터베이스에 도달해야 이름이 중복되었는지를 확인할수있다.

artist = Repo.get_by(Artist, name: "Johnny Hodges")
artist_changeset = Artist.changeset(artist,
  %{name: "John Cornelius Hodges"})
genre_changeset =
  %Genre{}
  |> Ecto.Changeset.cast(%{name: "jazz"}, [:name])
  |> Ecto.Changeset.unique_constraint(:name)
multi =
  Multi.new
  |> Multi.update(:artist, artist_changeset)
  |> Multi.insert(:bad_genre, genre_changeset)
Repo.transaction(multi)
#=> {:error, :bad_genre, #Ecto.Changeset< ... >,
#=> %{
#=>     artist: %MusicDB.Artist{
#=>     __meta__: #Ecto.Schema.Metadata<:loaded, "artists">,
#=>     albums: #Ecto.Association.NotLoaded<association
#=>     :albums is not loaded>,
#=>     birth_date: nil,
#=>     death_date: nil,
#=>     id: 4,
#=>     inserted_at: ~N[2018-03-23 14:02:28],
#=>     name: "John Cornelius Hodges",
#=>     tracks: #Ecto.Association.NotLoaded<association
#=>     :tracks is not loaded>,
#=>     updated_at: ~N[2018-03-23 14:02:28]
#=>    }
#=> }}
