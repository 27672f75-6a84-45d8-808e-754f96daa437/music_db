alias MusicDB.Repo

Repo.insert_all("artists", [[name: "John Coltrane"]]) #=> {1, nil}

Repo.insert_all("artists", [[name: "Sonny Rollins", inserted_at: DateTime.utc_now()]]) #=> {1, nil}

Repo.insert_all("artists",
[[name: "Max Roach", inserted_at: DateTime.utc_now()],
[name: "Art Blakey", inserted_at: DateTime.utc_now()]]) #=> {2, nil}

Repo.insert_all("artists",
[%{name: "Max Roach", inserted_at: DateTime.utc_now()},
%{name: "Art Blakey", inserted_at: DateTime.utc_now()}])

# artists 테이블에 저장된 모든 updated_at 컬럼을 현재 시각으로 업데이트함.
Repo.update_all("artists", set: [updated_at: DateTime.utc_now()])
