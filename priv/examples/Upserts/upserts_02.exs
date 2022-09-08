# 스키마를 사용하여 값을 넣을때
genre = %Genre{name: "funk", wiki_tag: "Funk"}
Repo.insert(genre)
#=> {:ok,
#=> %MusicDB.Genre{__meta__: #Ecto.Schema.Metadata<:loaded, "genres">,
#=> albums: #Ecto.Association.NotLoaded<association :albums is not loaded>,
#=> id: 3, inserted_at: ~N[2018-03-05 14:26:13], name: "funk",
#=> updated_at: ~N[2018-03-05 14:26:13], wiki_tag: "Funk"}}

# insert에 on_conflict 옵션 또한 줄수있다.
Repo.insert(genre, on_conflict: [set: [wiki_tag: "Funk_music"]],
conflict_target: :name)
#=> {:ok,
#=> %MusicDB.Genre{__meta__: #Ecto.Schema.Metadata<:loaded, "genres">,
#=> albums: #Ecto.Association.NotLoaded<association :albums is not loaded>,
#=> id: 3,inserted_at: ~N[2018-03-05 14:27:14], name: "funk",
#=> updated_at: ~N[2018-03-05 14:27:14], wiki_tag: "Funk"}} // ?? 하지만 분명히 충돌했을시에 값을 바꿨는데 wiki_tag가 바뀌어있지 않다

# 데이터베이스를 조회해보니 값은 정상적으로 바뀌어있다.
Repo.get(Genre, 3)
#=> %MusicDB.Genre{__meta__: #Ecto.Schema.Metadata<:loaded, "genres">,
#=> albums: #Ecto.Association.NotLoaded<association :albums is not loaded>,
#=> id: 3,inserted_at: ~N[2018-03-05 14:26:13], name: "funk",
#=> updated_at: ~N[2018-03-05 14:26:13], wiki_tag: "Funk_music"}

# wiki_tag의 값은 변했다.
# 그리고 inserted_at과 updated_at값은 변하지 않았다.
# 데이터베이스의 record는 정확하다 하지만 insert를 사용한 return값은 그것을 반영하지 않았다.
# 그 이유는 :on_conflict를 키워드 리스트에 사용할때 Ecto는 upsert를 수행한후 전체 레코드를 다시 읽지 않기 때문이다.
# 업데이트 중인 값과 Ecto에게 반환을 요청한 값 사이에 불일치가 있으면 반환된 구조체가 데이터베이스에 있는 값을 정확하게 반영하지 못할수도있다.

# replace_all_except_primary_key를 사용하여 key를 제외한 모든 값을 우리가 준 구조체 값으로 변경한다.
genre = %Genre{name: "funk", wiki_tag: "Funky_stuff"}
Repo.insert(genre, on_conflict: :replace_all_except_primary_key,
conflict_target: :name)
#=> {:ok,
#=>   %MusicDB.Genre{
#=>     __meta__: #Ecto.Schema.Metadata<:loaded, "genres">,
#=>     albums: #Ecto.Association.NotLoaded<association :albums is not loaded>,
#=>     id: 3, inserted_at: ~N[2018-03-05 23:01:28], name: "funk",
#=>     updated_at: ~N[2018-03-05 23:01:28], wiki_tag: "Funky_stuff" }}
