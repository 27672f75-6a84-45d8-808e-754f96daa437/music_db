defmodule MusicDB.Composition do
  use Ecto.Schema
  alias MusicDB.{Artist}

  schema "compositions" do
    field(:title)
    field(:year)
    timestamps()

    many_to_many(:artists, Artist, join_through: "compostions_artists")
  end
end
