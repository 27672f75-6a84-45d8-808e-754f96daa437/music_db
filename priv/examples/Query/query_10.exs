q = from a in "albums",
  join: ar in "artists", on: a.artist_id == ar.id,
  where: ar.name == "Miles Davis",
  select: [a.title]
Repo.all(q)
#=> [["Cookin' At The Plugged Nickel"], ["Kind Of Blue"]]
