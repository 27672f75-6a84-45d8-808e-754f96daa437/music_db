Repo.insert(%Genre{name: "speed polka"})

Repo.insert(%Genre{name: "speed polka"})

#=>
#=> ** (Ecto.ConstraintError) constraint error when attempting to insert
#=> struct:
#=>
#=> * unique: genres_name_index
#=>
#=> If you would like to convert this constraint into an error, please
#=> call unique_constraint/3 in your changeset and define the proper
#=> constraint name. The changeset has not defined any constraint.

# constriant 에러를 받는다 해당 에러는 데이터베이스에서 오는 에러이다.

Repo.insert!(%Genre{ name: "bebop" })

params = %{"name" => "bebop"}
changeset =
  %Genre{}
  |> cast(params, [:name])
  |> validate_required(:name)
  |> validate_length(:name, min: 3)
  |> unique_constraint(:name)
changeset.errors
#=> []

# 위에서 같은 값을 넣었는데도 아무런 오류가 나오지 않는것 또한 constraint는 Repo를 통해 데이터베이스에 요청했을때 오류 내역을 확인할 수 있기 때문

params = %{"name" => "bebop"}
changeset =
%Genre{}
  |> cast(params, [:name])
  |> validate_required(:name)
  |> validate_length(:name, min: 3)
  |> unique_constraint(:name)
case Repo.insert(changeset) do
  {:ok, _genre} -> IO.puts "Success!"
  {:error, changeset} -> IO.inspect changeset.errors
end
#=> [name: {"has already been taken", []}]

# Repo에 insert를 실행하고 난뒤 결과에 이미 등록된 이름이라는 오류 메시지가 출력된다.
