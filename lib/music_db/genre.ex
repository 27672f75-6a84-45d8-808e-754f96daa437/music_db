defmodule MusicDB.Genre do
  use Ecto.Schema
  alias MusicDB.{Album}
  import Ecto.Changeset

  schema "genres" do
    field(:name)
    field(:wiki_tag)
    timestamps()

    many_to_many(:albums, Album, join_through: "albums_genres")
  end

  def changeset(genre, params) do
    genre
    |> cast(params, [:name])
    |> validate_required([:name])
    |> validate_length(:name, [{:min, 1}, {:max, 15}])
    |> validate_inclusion(:name, ["jazz", "rock", "pop", "hiphop", "heavyrock"])
    |> unique_constraint(:name)
  end
end
