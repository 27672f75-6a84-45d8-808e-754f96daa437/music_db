defmodule MusicDB.Repo.Migrations.AddCompositionArtistsTable do
  use Ecto.Migration
  import Ecto.Query
  alias MusicDB.Repo

  @table "compositions_artists"
  # migrate를 수행할때 실행된다.
  def up do
    create table(@table) do
      add :composition_id, references("compositions"), null: false
      add :artist_id, references("artists"), null: false
      add :role, :string, null: false
    end

    create index("compositions_artists", :composition_id)
    create index("compositions_artists", :artist_id)

    # Ecto는 flush()위의 내용을 우선 실행하고 다음으로 진행을 넘어간다.
    flush()

    # 기존에 compositions에 등록된 artist_id들을 새로운 테이블인 compositions_artists로 옮긴다.
    from(c in "compositions", select: [:id, :artist_id])
    |> Repo.all()
    |> Enum.each(fn row ->
      Repo.insert_all("compositions_artists", [
        [composition_id: row.id, artist_id: row.artist_id, role: "composer"]
      ])
    end)

    # 더이상 필요가 없기때문에 지운다.
    alter table("compositions") do
      remove :artist_id
    end
  end

  # rollback을 할때 실행된다.
  def down do

    # 우선 compositions에서 지웠던 컬럼을 다시 추가하고
    alter table("compositions") do
      add :artist_id, references("artists")
    end

    flush()

    #composition_artists에 있던 데이터를 다시 옮긴다.
    from(ca in "compositions_artists", where: ca.role == "composer",
        select: [:composition_id, :artist_id])
    |> Repo.all()
    |> Enum.each(fn row ->
      Repo.update_all(
        from(c in "compositions", where: c.id == ^row.composition_id),
        set: [artist_id: row.artist_id]
      )
      end)

    # 데이터를 다 옮겼으니 해당 테이블을 제거한다.
    drop table("compositions_artists")
  end
end
