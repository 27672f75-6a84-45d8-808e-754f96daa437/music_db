defmodule MusicDB.Album do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias MusicDB.{Artist, Track, Genre, Repo}

  schema "albums" do
    field(:title, :string)
    field(:average_total_tracks_durations, :decimal, [{:virtual, true}])
    timestamps()

    # 다른 스키마와 one-to-one 또는 many-to-one 연결을 나타낸다.
    # 현재 스키마는 다른 스키마와 0개 또는 하나의 레코드에 속하지만
    # 지금 이 스키마와 연관되있는 스키마는 has_one 또는 has_many로 연관되있을수도있다.
    # artist 와 관계를 맺고있고 추후에 :preload 옵션을 추가하여 연관되있는 가수값을 가져올수있다.
    belongs_to(:artist, Artist)
    has_many(:tracks, Track)
    many_to_many(:genres, Genre, join_through: "albums_genres")
  end

  def changeset(album, params) do
    album
    |> cast(params, [:title])
    |> validate_required([:title])
    |> validate_length(:title, [{:min, 1}, {:max, 10}])
  end

  def new_album_by_API(album_name) do
    %__MODULE__{}
    |> cast(%{"title" => album_name}, [:title])
    |> validate_required([:title])
    |> validate_length(:title, [{:min, 3}, {:max, 15}])
  end

  # union을 사용하면 중복결과 없이 고유한 결과만 나온다.
  def get_all_albums_and_tracks_title() do
    tracks_query = from(track in Track, [{:select, track.title}])
    from(album in __MODULE__, [{:select, album.title}, {:union, ^tracks_query}])
  end

  # union_all을 사용하면 모든 결과가 합쳐져서 나온다.
  def get_union_all_albums_and_tracks_title() do
    tracks_query = from(track in Track, [{:select, track.title}])
    from(album in __MODULE__, [{:select, album.title}, {:union_all, ^tracks_query}])
  end

  # 앨범 제목이면서도 트랙의 제목인것을 가져옴.
  def get_intersect_albums_and_tracks_title() do
    tracks_query = from(track in Track, [{:select, track.title}])
    from(album in __MODULE__, [{:select, album.title}, {:intersect, ^tracks_query}])
  end

  # 앨범 제목이면서 트랙의 제목이 아닌것을 가져옴.
  def get_except_albums_and_tracks_title() do
    tracks_query = from(track in Track, [{:select, track.title}])

    from(album in __MODULE__, [
      {:select, album.title},
      {:except, ^tracks_query}
    ])
  end

  # 앨범이름과 곡 이름이 같지 않은 앨범을 가져옴
  def get_except_albums_and_tracks_last_title() do
    same_track_album_by_title_query =
      from(album in __MODULE__, [
        {:as, :albums},
        {:join, track in assoc(album, :tracks)},
        {:on, album.title == track.title},
        {:distinct, album.title},
        {:select, album}
      ])

    from(album in __MODULE__, [
      {:except, ^same_track_album_by_title_query},
      {:select, album}
    ])
  end

  def get_album_title_list_by_artist_name(artist_name) do
    from(album in __MODULE__, [
      {:join, artist in Artist},
      {:on, album.artist_id == artist.id},
      {:where, artist.name == type(^artist_name, :string)},
      {:select, [album.title]}
    ])
  end

  def get_track_title_list_by_artist_name(artist_name) do
    from(album in __MODULE__, [
      {:join, artist in Artist},
      {:on, album.artist_id == artist.id},
      {:join, track in Track},
      {:on, track.album_id == album.id},
      {:where, artist.name == type(^artist_name, :string)},
      {:select, [track.title]}
    ])
  end

  # 쿼리문에서 쿼리를 바인딩하고
  # 다음 쿼리에서 바인딩한 쿼리를 갖고 album과 artist의 이름에 접근한 쿼리를 반환함.
  def get_albums_by_miles do
    albums_by_miles =
      from(album in __MODULE__, [
        {:as, :albums},
        {:join, artist in Artist},
        {:as, :artists},
        {:on, album.artist_id == artist.id},
        {:where, artist.name == "Miles Davis"}
      ])

    from([artists: artist, albums: album] in albums_by_miles, [
      {:select, [album.title, artist.name]}
    ])
  end

  # 주어진 아티스트의 이름을 가진 앨범을 가져오는 쿼리
  def by_artist(album_query \\ __MODULE__, artist_name) do
    from(album in album_query, [
      {:as, :album},
      {:join, artist in Artist},
      {:as, :artist},
      {:on, album.artist_id == artist.id},
      {:where, artist.name == ^artist_name}
    ])
  end

  def by_artist_or(album_query, artist_name) do
    from([album: album, artist: artist] in album_query, [
      # 이곳에서 where절로 한다면 후에 쿼리문에서 AND로 묶여지게된다.
      {:or_where, artist.name == ^artist_name},
      {:select, %{artist_name: artist.name, album_title: album.title}}
    ])
  end

  # 주어진 duration 보다 긴 곡을 가진 앨범을 가져오는 쿼리
  def with_tracks_longer_than(album_query, duration) do
    from(album in album_query, [
      {:join, track in Track},
      {:on, track.album_id == album.id},
      {:where, track.duration > ^duration},
      {:distinct, true}
    ])
  end

  def title_only(album_query) do
    from(album in album_query, [
      {:select, album.title}
    ])
  end

  # 주어진 가수 이름을 가진 앨범에서 주어진 duration 보다 긴 곡을 가진 앨범을 조회하는 쿼리
  def get_album_by_artist_with_tracks_longer_than_duration_title_onlty(artist_name, duration) do
    by_artist(artist_name)
    |> with_tracks_longer_than(duration)
    |> title_only()
  end
end
