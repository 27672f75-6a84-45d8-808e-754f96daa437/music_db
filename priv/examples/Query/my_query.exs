
곡 중에서 제일 짧은곡 가져오기
from(track in Track, [
  {:select, track}
])
|> first(:duration)
|> Repo.one

SELECT   t0."id",
         t0."title",
         t0."duration",
         t0."index",
         t0."number_of_plays",
         t0."inserted_at",
         t0."updated_at",
         t0."album_id"
FROM     "tracks" AS t0
ORDER BY t0."duration" limit 1 []
