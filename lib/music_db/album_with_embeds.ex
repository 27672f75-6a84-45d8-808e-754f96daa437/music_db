defmodule MusicDB.AlbumWithEmbeds do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias MusicDB.{ArtistEmbed, TrackEmbed}

  schema "albums_with_embeds" do
    field(:title, :string)
    embeds_one(:artist, ArtistEmbed, [{:on_replace, :update}])
    embeds_many(:tracks, TrackEmbed, [{:on_replace, :delete}])
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:title])
    |> cast_embed(:artist)
    |> cast_embed(:tracks)
    |> validate_required([:title])
    |> validate_length(:title, [{:min, 1}, {:max, 100}])
  end

  def by_title(album_title) do
    from(album in __MODULE__, [
      {:where, album.title == ^album_title},
      {:lock, "FOR UPDATE"}
    ])
  end
end
