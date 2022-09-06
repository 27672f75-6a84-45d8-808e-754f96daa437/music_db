defmodule MusicDB.Repo.Migrations.AddCompositionsTable do
  use Ecto.Migration

  @table "compositions"

  def change do
    create table(@table) do
      add(:title, :string, [null: false] )
      add(:year, :integer, [null: false] )
      add(:artist_id, references("artists"), [null: false])
      add(:inserted_at, :timestamp, [{:null, false}, {:default, fragment("now()")}])
      add(:updated_at, :timestamp, [{:null, false}, {:default, fragment("now()")}])
    end
  end
end
