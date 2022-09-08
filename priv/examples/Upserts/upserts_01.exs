# 값 넣기
Repo.insert_all("genres", [[name: "ska", wiki_tag: "Ska_music"]])
# => {1, nil}

# 값을 또 넣으려고 하면 키가 중복된다는 에러메시지가 나온다
Repo.insert_all("genres", [[name: "ska", wiki_tag: "Ska_music"]])
# => ** (Postgrex.Error) ERROR 23505 (unique_violation): duplicate key
# => value violates unique constraint "genres_name_index"

# on_conflict 옵션을 nothing으로 주어 충돌시 아무런 일도 일어나지 않게했다.
Repo.insert_all("genres", [[name: "ska", wiki_tag: "Ska_music"]],
on_conflict: :nothing)
# => {0, nil} 결과에서 0은 데이터베이스에서 바뀐 레코드가 없다는것을 의미한다.

Repo.insert_all("genres", [[name: "ska", wiki_tag: "Ska"]],
on_conflict: {:replace, [:wiki_tag]}, returning: [:wiki_tag])
#=> ** (ArgumentError) :conflict_target option is required
#=> when :on_conflict is replace  // 어떤 값의 충돌을 검사할것인지 명시적으로 적어야한다. 여기서는 name이다.

# conflict_target을 명시적으로 적으니 충돌을 탐지하여 레코드를 넣었다 !
Repo.insert_all("genres", [[name: "ska", wiki_tag: "Ska"]],
on_conflict: {:replace, [:wiki_tag]}, conflict_target: :name,
returning: [:wiki_tag])
# => {1, [%{wiki_tag: "Ska"}]} // 새로운 값으로 업데이트되서 나온 값

# 새로운 값을 넣었더니 비슷한 결과를 얻었다.
# upsert는 insert update 여부와 무관하게 코드를 작성할수있게 해준다.
Repo.insert_all("genres", [[name: "ambient", wiki_tag: "Ambient_music"]],
on_conflict: {:replace, [:wiki_tag]}, conflict_target: :name,
returning: [:wiki_tag])
# => {1, [%{wiki_tag: "Ambient_music"}]}

# on_conflict 옵션을 살짝 손봐줄수있다.
# 마치 update_all 함수를 사용할때같다.
Repo.insert_all("genres", [[name: "ambient", wiki_tag: "Ambient_music"]],
on_conflict: [set: [wiki_tag: "Ambient_music"]],
conflict_target: :name, returning: [:wiki_tag])
