defmodule MusicDB.Repo.Migrations.AddAlbumsWithEmbeds do
  use Ecto.Migration

  @table "albums_with_embeds"
  def change do
    create table(@table) do
      add(:title, :string)
      add(:artist, :jsonb)
      add(:tracks, {:array, :jsonb}, default: [])
    end
  end
end
