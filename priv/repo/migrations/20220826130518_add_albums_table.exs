defmodule MusicDB.Repo.Migrations.AddAlbumsTable do
  use Ecto.Migration

  def change do
    create table(:albums) do
      add :title, :string, null: false # 제목은 null값이 될 수 없다.
       # artist_id를 추가할것인데 해당 값은 artists라는 외래키 ( 부모 테이블의 기본키를 자식 테이블로 가져오는 것 )를 사용하고
       # 외래키에는 식별관계와 비식별관계가 있는데 현재 외래키는 앨범이 달라도 부른 가수가 같을수 있으므로
       # 비식별관계 외래키를 사용한다. 만약 식별관계 외래키를 사용하고 싶다면 => Unique에 대해 공부하자.
       # 해당 참조 값이 지워질때 아무것도 하지 않는다라고 설정 ( 연계 참조 무결성 제약 nothing )
      add :artist_id, references(:artists, on_delete: :nothing)
      timestamps() # 시간을 넣을수 있음 무조건 넣어야함.
    end

    create index(:albums, :artist_id)
    # 인덱스를 추가하는 이유
    # 일반적으로 SELECT 구문을 통해 데이터 조회를 요청하는데
    # DB 서버 프로세스는 Memory (DB 버퍼 캐시)를 먼저 확인한다.
    # 메모리 (DB 버퍼 캐시) 에는 자주 사용되는 테이블이 캐싱 저장되어있는데
    # 원하는 데이터가 메모리에 있다면 빠른 쿼리 수행속도 조회가 가능하고
    # 없다면 하드의 모든 블록 테이블을 조회해야된다.
    # 때문에 테이블 풀 스캔을 막기위해 데이터의 주소록인 인덱스를 만들어서 데이터를 관리하는 것이다.
  end
end
