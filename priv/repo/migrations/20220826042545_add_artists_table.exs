defmodule MusicDB.Repo.Migrations.AddArtistsTable do
  use Ecto.Migration


  def change do
    create table(:artists) do # 항상 테이블은 복수형으로 쓰는걸 습관화하자
      add :name, :string, null: false # 이름은 null이면 안됌.
      add :birth_date, :date, null: true
      add :death_date, :date, null: true

      timestamps null: true
    end

    create index(:artists, :name)
  end
end
