defmodule MusicDB.Track do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias MusicDB.{Album, Artist, Note}

  schema "tracks" do
    field(:title, :string)
    field(:duration, :integer)
    # 데이터베이스에 저장되지 않는 가상 필드
    field(:duration_string, :string, virtual: true)
    field(:index, :integer)
    field(:number_of_plays, :integer)
    timestamps()
    has_many(:notes_with_fk_fields, Note)
    belongs_to(:album, Album)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :index, :number_of_plays])
    |> validate_required([:title])
  end

  # track의 앨범 id와 track의 index 순으로 정렬하여 반환.
  def get_sorted_track_by_albumid_index() do
    from(track in __MODULE__, [
      {:select, [track.album_id, track.title, track.index]},
      {:order_by, [track.album_id, track.index]}
    ])
  end

  # 트랙의 duration을 합치고 앨범 ID와 그룹화하여 반환.
  def get_duration_group_by_album_id() do
    from(track in __MODULE__, [
      {:select, [track.album_id, sum(track.duration)]},
      {:group_by, track.album_id}
    ])
  end

  # 주어진 시간 보다 긴 duration을 가진 앨범 아이디 반환
  def get_duration_group_by_album_id(over_number) do
    from(track in __MODULE__, [
      {:select, [track.album_id, sum(track.duration)]},
      {:group_by, track.album_id},
      {:having, sum(track.duration) > ^over_number}
    ])
  end

  # 제공한 duration보다 높은 duration을 가진 track의 앨범 제목과 트랙 제목을 반환함
  def get_join_track_album_id_title(over_duration) do
    from(track in __MODULE__, [
      {:join, album in Album},
      {:on, track.album_id == album.id},
      {:where, track.duration > ^over_duration},
      {:select, [album.title, track.title]}
    ])
  end

  def get_join_track_album_id_title_map(over_duration) do
    from(track in __MODULE__, [
      {:join, album in Album},
      {:on, track.album_id == album.id},
      {:where, track.duration > ^over_duration},
      {:select, %{album_title: album.title, track_title: track.title}}
    ])
  end

  def get_join_track_album_artist_map(over_duration) do
    from(track in __MODULE__, [
      {:join, album in Album},
      {:on, track.album_id == album.id},
      {:join, artist in Artist},
      {:on, album.artist_id == artist.id},
      {:where, track.duration > ^over_duration},
      {:select, %{album: album.title, track_title: track.title, artist_title: artist.name}}
    ])
  end

  def by_title(title) do
    from(
      track in __MODULE__,
      [
        {:where, track.title == ^title},
        {:lock, "FOR UPDATE"}
      ]
    )
  end
end
