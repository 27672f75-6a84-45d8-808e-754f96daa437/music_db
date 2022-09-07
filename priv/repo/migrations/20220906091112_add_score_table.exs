defmodule MusicDB.Repo.Migrations.AddScoreTable do
  use Ecto.Migration

  @table "scores"
  def change do
    create table(@table, primary_key: false) do
      add(:main_code, :string, [{:primary_key, true}])
      add(:track_id, references("tracks",[{:on_delete , :delete_all}]), [{:null, false}])
    end
  end
end
