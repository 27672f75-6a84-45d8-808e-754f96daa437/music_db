defmodule MusicDB.Repo.Migrations.AddNotesJoinTables do
  use Ecto.Migration

  def change do
    create table(:artists_notes) do
      add :artist_id, references(:artists)
      add :note_id, references(:notes_with_joins)
    end
    create index(:artists_notes, :artist_id)
    create index(:artists_notes, :note_id)

    create table(:albums_notes) do
      add :album_id, references(:albums)
      add :note_id, references(:notes_with_joins)
    end
    create index(:albums_notes, :album_id)
    create index(:albums_notes, :note_id)

    create table(:tracks_notes) do
      add :track_id, references(:tracks)
      add :note_id, references(:notes_with_joins)
    end
    create index(:tracks_notes, :track_id)
    create index(:tracks_notes, :note_id)
  end
end
