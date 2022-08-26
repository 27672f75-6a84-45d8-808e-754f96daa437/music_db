defmodule MusicDB.Artist do
  use Ecto.Schema
  alias MusicDB.{Album}

  schema "artists" do
    field(:name)
    field(:birth_date, :date)
    field(:death_date, :date)
    timestamps()

    # album 과 관계를 맺고있고 추후에 preload 옵션을 추가하여 연관되있는 가수값을 가져올수있다.
    has_many(:albums, Album)
  end
end
