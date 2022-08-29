tracks_query = from(track in "tracks", [{:select, [track.title]}])
union_query = from(album in "albums",[{:select, [album.title]}, {:union ,^tracks_query}])
