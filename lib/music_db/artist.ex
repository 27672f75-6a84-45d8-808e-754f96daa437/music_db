defmodule MusicDB.Artist do
  use Ecto.Schema

  schema "artists" do
    field(:name)
    field(:birth_date, :date)
    field(:death_date, :date)
    timestamps()
  end
end
