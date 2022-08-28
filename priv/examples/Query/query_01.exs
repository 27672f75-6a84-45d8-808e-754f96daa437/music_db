SELECT t.id, t.title, a.title
  FROM tracks t
  JOIN albums a ON t.album_id = a.id
  WHERE t.duration > 900;

# Ecto로 위의 쿼리문을 다음과 같이 작성할수있다.

query = from t in "tracks",
  join: a in "albums", on: t.album_id == a.id,
  where: t.duration > 900,
  select: [t.id, t.title, a.title]
