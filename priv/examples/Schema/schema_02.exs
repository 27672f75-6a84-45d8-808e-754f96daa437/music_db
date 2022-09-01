artist_id = "1"
q = from "artists", where: [id: type(^artist_id, :integer)], select: [:name]
Repo.all(q)
#=> [%{name: "Miles Davis"}]

# type 함수를 통해서 string으로 받은 artist_id를 int형으로 cast하였고
# select에서는 우리가 원해는 컬럼인 :name을 제공하여 원하는 값을 받았다

alias MusicDB.Track

track_id = "1"
q = from Track, where: [id: ^track_id]

# 다음과 같이 alias 를 추가함으로써 모듈의 풀네임을 적지 않을수있고
# string으로 제공했던 "tracks" 이름을 모듈이름을 통해 가져오도록 할 수 있다.

# 그리고 select: 절을 생략하여도 Ecto는 모든 필드가 정의된 스키마를 select절을 수행하여 반환해준다.

q = from Track, where: [id: ^track_id], select: [:title]
Repo.all(q)
#=> [%MusicDB.Track{__meta__: #Ecto.Schema.Metadata<:loaded, "tracks">,
#=> album: #Ecto.Association.NotLoaded<association :album is not loaded>,
#=> album_id: nil, duration: nil, id: nil, index: nil, inserted_at: nil,
#=> number_of_plays: nil, title: "So What", updated_at: nil}]

# select절에서 선택하지 않은 값에는 모두 nil값으로 채워지게된다.

# 바로 쿼리 바인딩을 사용하지 않아서이다.
# 쿼리 바인딩을 사용하여 위의 쿼리를 다음과 같이 수정할수있다.

q = from t in Track, where: t.id == ^track_id
