defmodule MusicDB.Artist do
  use Ecto.Schema
  import Ecto.Query
  alias MusicDB.{Album}

  schema "artists" do
    field(:name)
    field(:birth_date, :date)
    field(:death_date, :date)
    timestamps()

    # album 과 관계를 맺고있고 추후에 preload 옵션을 추가하여 연관되있는 가수값을 가져올수있다.
    has_many(:albums, Album)
    # :through를 사용하여 현재 모듈에서 이전에 정의된 albums 연관이 있고
    # 해당 albums를 사용하여 관계있는 :tracks 스키마를 가르키게끔 설정한다.
    # 이 :through 연결은 추후에 아티스트를 가져올때 앨범과 그 앨범에 속한 트랙을 가져오도록 할수있다.
    has_many(:tracks, through: [:albums, :tracks])
  end

  def get_by_name(artist_name) do
    from(artist in __MODULE__, [
      {:where, artist.name == type(^artist_name, :string)},
      {:select, [:name]}
    ])
  end

  def get_by_id(id) do
    from(artist in __MODULE__, [
      {:where, artist.id == type(^id, :integer)},
      {:preload, :albums},
      {:preload, :tracks}
    ])
  end
end
