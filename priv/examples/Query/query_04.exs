artist_id = 1
q = from "artists", where: [id: ^artist_id], select: [:name]
Repo.all(q)
#=> [%{name: "Miles Davis"}]

# 위의 구문은 정상 동작을 한다

artist_id = "1"
q = from "artists", where: [id: ^artist_id], select: [:name]
Repo.all(q)


#=> ** (DBConnection.EncodeError) Postgrex expected an integer
#=> in -2147483648..2147483647 that can be encoded/cast to
#=> type "int4", got "1". Please make sure the value you
#=> are passing matches the definition in your table or
#=> in your query or convert the value accordingly.

# Postgres에서는 id에 값을 넣기 때문에 integer 값이 들어올줄알았으나 binary형식인 "1"값이 들어와 에러가 생긴다.

artist_id = "1"
q = from "artists", where: [id: type(^artist_id, :integer)], select: [:name]
Repo.all(q)
#=> [%{name: "Miles Davis"}]

# 위와 같이 type을 명시하면 Ecto.Query가 변수의 값을 type에 명시된 값으로 캐스팅하게 된다.
