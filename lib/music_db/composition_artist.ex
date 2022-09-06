defmodule MusicDB.CompositionArtist do
  use Ecto.Schema
  alias MusicDB.{Artist, Composition}

  schema "compostions_artists" do
    belongs_to(:artists, Artist)
    belongs_to(:compositions, Composition)
  end
end
