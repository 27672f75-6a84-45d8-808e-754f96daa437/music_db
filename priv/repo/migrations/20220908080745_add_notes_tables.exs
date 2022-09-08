defmodule MusicDB.Repo.Migrations.AddNotesTables do
  use Ecto.Migration



  @table :notes_with_fk_fields
  def change do

    create table(@table) do
      add(:note, :text, [{:null, false}])
      add(:author, :string, [{:null, false}])
      add(:artist_id , references(:artists))
      add(:album_id,  references(:albums))
      add(:track_id,  references(:tracks))
      timestamps()
    end

    if MusicDB.Repo.using_postgres?() do
      fk_check = """
        (CASE WHEN artist_id IS NULL THEN 0 ELSE 1 END) +
        (CASE WHEN album_id IS NULL THEN 0 ELSE 1 END) +
        (CASE WHEN track_id IS NULL THEN 0 ELSE 1 END) = 1
      """
      create constraint(:notes_with_fk_fields, :only_one_fk, check: fk_check)
    end

    create table(:notes_for_artists) do
      add :note, :text, null: false
      add :author, :string, null: false
      add :assoc_id, references(:artists)
      timestamps()
    end

    create table(:notes_for_albums) do
      add :note, :text, null: false
      add :author, :string, null: false
      add :assoc_id, references(:albums)
      timestamps()
    end

    create table(:notes_for_tracks) do
      add :note, :text, null: false
      add :author, :string, null: false
      add :assoc_id, references(:tracks)
      timestamps()
    end

    create table(:notes_with_joins) do
      add :note, :text, null: false
      add :author, :string, null: false
      timestamps()
    end

  end
end
