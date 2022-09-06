defmodule MusicDB.Repo.Migrations.AddCompositionArtistsTable do
  use Ecto.Migration

  def change do
    create table("compositions_artists") do
      add :composition_id, references("compositions"), null: false
      add :artist_id, references("artists"), null: false
      add :role, :string, null: false
    end

    create index("compositions_artists", :composition_id)
    create index("compositions_artists", :artist_id)
  end
end
