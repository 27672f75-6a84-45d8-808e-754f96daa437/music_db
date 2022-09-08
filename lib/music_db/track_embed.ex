defmodule MusicDB.TrackEmbed do
  import Ecto.Changeset
  use Ecto.Schema

  embedded_schema do
    field(:title, :string)
    field(:duration, :integer)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :durations])
    |> validate_required([:title])
  end
end
