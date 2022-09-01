defmodule MusicDB.Track do
  defstruct [:id, :title, :duration, :index, :number_of_plays]
end

# Ecto의 스키마는 이와 유사하지만 아래와 같이 작성한다.
defmodule MusicDB.Track do
  use Ecto.Schema

  schema "tracks" do
    field :title, :string
    field :duration, :integer
    field :index, :integer
    field :number_of_plays, :integer
    timestamps()
  end
end
