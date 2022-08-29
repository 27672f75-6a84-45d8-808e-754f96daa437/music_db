q = from "artists", where: [name: "Bill Evans"], select: [:id, :name]
Repo.all(q)
#=> [%{id: 2, name: "Bill Evans"}]

artist_name = "Bill Evans"
q = from "artists", where: [name: artist_name], select: [:id, :name]

# 위 구문은 실행될것처럼 보인다 하지만 실제로는 동작하지 않고 에러를 받게된다

#** (Ecto.Query.CompileError) variable `artist_name` is not a valid query
#expression. Variables need to be explicitly interpolated in queries with ^
#...
