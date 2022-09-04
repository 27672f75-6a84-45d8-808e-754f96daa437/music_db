import Ecto.Changeset
changeset = change(%Artist{name: "Charlie Parker"})

artist = Repo.get_by(Artist, name: "Bobby Hutcherson")
changeset = change(artist)

# 데이터를 바꿀때 기본적으로 Repo를 통해 데이터베이스에서 가져온 값을 change한다.
artist = Repo.get_by(Artist, name: "Bobby Hutcherson")
changeset = change(artist, name: "Robert Hutcherson")

changeset.chages
#=> %{name: "Robert Hutcherson"}

# 값을 한번에 두개 바꾸는것 또한 가능하다.
artist = Repo.get_by(Artist, name: "Bobby Hutcherson")
changeset = change(artist, name: "Robert Hutcherson",
birth_date: ~D[1941-01-27])
