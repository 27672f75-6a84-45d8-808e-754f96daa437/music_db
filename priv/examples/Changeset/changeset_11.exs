params = %{"name" => "Esperanza Spalding",
  "albums" => [%{"title" => "Junjo"}]}
changeset =
  %Artist{}
  |> cast(params, [:name])
  |> cast_assoc(:albums)
changeset.changes

# 이 함수를 해당하는 스키마에 구현해야 오류가 발생하지 않는다.
# add this to lib/music_db/album.ex
def changeset(album, params) do
  album
  |> cast(params, [:title])
  |> validate_required([:title])
end

# 사용될 함수를 오버라이딩 할수도있다.
|> cast_assoc(:albums, with: &SomeModule.some_function/2)
