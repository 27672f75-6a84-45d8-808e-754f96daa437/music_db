defmodule MusicDB.Album do
  use Ecto.Schema
  alias MusicDB.{Artist}

  schema "albums" do
    field(:title, :string)
    timestamps()

    # 다른 스키마와 one-to-one 또는 many-to-one 연결을 나타낸다.
    # 현재 스키마는 다른 스키마와 0개 또는 하나의 레코드에 속하지만
    # 지금 이 스키마와 연관되있는 스키마는 has_one 또는 has_many로 연관되있을수도있다.
    # artist 와 관계를 맺고있고 추후에 :preload 옵션을 추가하여 연관되있는 가수값을 가져올수있다.
    belongs_to(:artist, Artist)
  end
end
