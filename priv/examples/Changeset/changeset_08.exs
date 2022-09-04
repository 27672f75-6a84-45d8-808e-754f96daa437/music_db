# 데이터 형식을 하나 정의함
form = %{artist_name: :string, album_title: :string,
          artist_birth_date: :date, album_release_date: :date,
          genre: :string}

# 사용자의 데이터
params = %{"artist_name" => "Ella Fitzgerald", "album_title" => "",
    "artitst_birth_date" => "", "album_release_date" => "",
    "genre" => ""}

changeset =
  {%{}, form}
  |> cast(params, Map.keys(form))
  |> validate_in_the_past(:artist_birth_date)
  |> validate_in_the_past(:album_release_date)

if changeset.valid? do
  # execute the advanced search
else
  # show changeset.errors to the user
end
