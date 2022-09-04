params = %{"name" => "Thelonius Monk", "birth_date" => "2117-10-10"}
changeset =
%Artist{}
|> cast(params, [:name, :birth_date])
|> validate_change(:brith_date, fn :birth_date, birth_date ->
  cond do
    is_nil(birth_date) -> []
    Date.compare(birth_date, Date.uth_today()) == :lt -> []
    true -> [birth_date: "must be in the past"]
  end
end)
changeset.erros
#=> [birth_date: {"must be in the past", []}]

# 함수로 감싸보자

def validate_birth_date_in_the_past(changeset) do
  validate_change(changeset, :birth_date, fn :birth_date, birth_date ->
    cond do
      is_nil(birth_date) ->[]
      Date.compare(birth_date, Date.utc_today()) == :lt -> []
      true -> [birth_date: "must be in the past"]
    end
  end)
end

# 위의 함수같은 경우는 :birth_date 필드밖에 받지 못한다.

def validate_in_the_past(changeset, field) do
  validate_change(changeset, field, fn _field, value ->
    cond do
      is_nil(value) -> []
      Date.compare(value, Date.utc_today()) == :lt -> []
      true -> [{field, "must be in the past"}]
    end
  end)
end

# 맨 처음 작성했던 코드를 위의 함수를 사용해 마무리해보자

params = %{"name" => "Thelonius Monk", "birth_date" => "2117-10-10"}
changeset =
  %Artist{}
  |> cast(params, [:name, :birth_date])
  |> validate_required(:name)
  |> validate_in_the_past(:birth_date)
