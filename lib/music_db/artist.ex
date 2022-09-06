defmodule MusicDB.Artist do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias MusicDB.{Album, Composition}

  schema "artists" do
    field(:name)
    field(:birth_date, :date)
    field(:death_date, :date)
    timestamps()

    # album 과 관계를 맺고있고 추후에 preload 옵션을 추가하여 연관되있는 가수값을 가져올수있다.
    has_many(:albums, Album, on_replace: :nilify)
    # :through를 사용하여 현재 모듈에서 이전에 정의된 albums 연관이 있고
    # 해당 albums를 사용하여 관계있는 :tracks 스키마를 가르키게끔 설정한다.
    # 이 :through 연결은 추후에 아티스트를 가져올때 앨범과 그 앨범에 속한 트랙을 가져오도록 할수있다.
    has_many(:tracks, through: [:albums, :tracks])
    many_to_many(:compositions, Composition, join_through: "compostions_artists")
  end

  def changeset(artist, params \\ %{}) do
    artist
    |> cast(params, [:name, :birth_date, :death_date])
    |> cast_assoc(:albums)
    |> validate_required([:name])
    |> validate_death_date()
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

  def get_sort_artist_by_name() do
    from(artist in __MODULE__, [
      {:select, artist.name},
      {:order_by, artist.name}
    ])
  end

  def get_desc_sort_artist_by_name() do
    from(artist in __MODULE__, [
      {:select, artist.name},
      {:order_by, [desc: artist.name]}
    ])
  end

  defp validate_death_date(changeset) do
    validate_change(changeset, :birth_date, fn _field, value ->
      cond do
        is_nil(value) -> []
        Date.compare(value, changeset[:death_date]) == :lt -> []
        true -> [{:death_date, "death_date must be later than birth_date"}]
      end
    end)
  end
end
