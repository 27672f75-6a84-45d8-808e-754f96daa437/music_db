alias MusicDB.{Repo, Artist}

# insert a record into the artists table
Repo.insert(%Artist{name: "Dizzy Gillespie"})
# retrieve the record
dizzy = Repo.get_by(Artist, name: "Dizzy Gillespie")
# make a change
Repo.update(Ecto.Changeset.change(dizzy, name: "John Birks Gillespie"))
# retrieve it again
dizzy = Repo.get_by(Artist, name: "John Birks Gillespie")
# delete it
Repo.delete(dizzy)
