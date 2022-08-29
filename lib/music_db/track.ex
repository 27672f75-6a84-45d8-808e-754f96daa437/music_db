defmodule MusicDB.Track do
  use Ecto.Schema
  import Ecto.Query
  alias MusicDB.Album

  schema "tracks" do
    field(:title, :string)
    field(:duration, :integer)
    # 데이터베이스에 저장되지 않는 가상 필드
    field(:duration_string, :string, virtual: true)
    field(:index, :integer)
    field(:number_of_plays, :integer)
    timestamps()

    belongs_to(:album, Album)
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
  def get_duration_group_by_album_id(under_number) do
    from(track in __MODULE__, [
      {:select, [track.album_id, sum(track.duration)]},
      {:group_by, track.album_id},
      {:having, sum(track.duration) > ^under_number}
    ])
  end
end
