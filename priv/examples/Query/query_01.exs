SELECT t.id, t.title, a.title
  FROM tracks t
  JOIN albums a ON t.album_id = a.id
  WHERE t.duration > 900;

# Ecto로 위의 쿼리문을 다음과 같이 작성할수있다.

query = from t in "tracks",
  join: a in "albums", on: t.album_id == a.id,
  where: t.duration > 900,
  select: [t.id, t.title, a.title]

query = "tracks"
|> join(:inner, [t], a in "albums", on: t.album_id == a.id)
|> where([t,a], t.duration > 900)
|> select([t,a], [t.id, t.title, a.title])

query = from "artists", select: [:name]
#=> #Ecto.Query<from a in "artists", select: [:name]>

query = from "artits", select: [:name]
Ecto.Adapters.SQL.to_sql(:all, Repo, query)
#=> {"SELECT a0.\"name\" FROM \"artists\" AS a0", []}

query = from "artists", select: [:name]
Repo.to_sql(:all, query)
