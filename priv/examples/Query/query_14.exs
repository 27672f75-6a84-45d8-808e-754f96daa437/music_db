q = from t in "tracks", where: t.title == "Autum Leaves"
Repo.update_all(q, set: [title: "Autumn Leaves"])

# 쿼리문을 수행해 해당 테이블을 업데이트할수있다.
from(t in "tracks", where: t.title == "Autum Leaves")
|> Repo.update_all(set: [title: "Autumn Leaves"])

# 제거도 물론 가능하다.
from(t in "tracks", where: t.title == "Autum Leaves")
|> Repo.delete_all
