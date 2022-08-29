tracks_query = from(track in "tracks", [{:select, [track.title]}])
union_query = from(album in "albums",[{:select, [album.title]}, {:union ,^tracks_query}])

q = from artist in "artists", select: [artist.name], order_by: artist.name
#=> [["Bill Evans"], ["Bobby Hutcherson"], ["Miles Davis"]]

q = from a in "artists", select: [a.name], order_by: [desc: a.name]
Repo.all(q)
#=> [["Miles Davis"], ["Bobby Hutcherson"], ["Bill Evans"]]
