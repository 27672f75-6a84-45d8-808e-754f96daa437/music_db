defmodule MusicDB.Album do
  use Ecto.Schema
  import Ecto.Query
  alias MusicDB.{Artist, Track}

  schema "albums" do
    field(:title, :string)
    timestamps()

    # 다른 스키마와 one-to-one 또는 many-to-one 연결을 나타낸다.
    # 현재 스키마는 다른 스키마와 0개 또는 하나의 레코드에 속하지만
    # 지금 이 스키마와 연관되있는 스키마는 has_one 또는 has_many로 연관되있을수도있다.
    # artist 와 관계를 맺고있고 추후에 :preload 옵션을 추가하여 연관되있는 가수값을 가져올수있다.
    belongs_to(:artist, Artist)
    has_many(:tracks, Track)
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
    from(album in __MODULE__, [{:select, album.title}, {:except, ^tracks_query}])
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
end
