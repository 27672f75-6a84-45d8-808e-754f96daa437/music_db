alias MusicDB.Repo

Repo.insert_all("artists", [%{name: "Max Roach"}, %{name: "Art Blakey"}], returning: [:id, :name]) #=> {2, [%{id: 12, name: "Max Roach"}, %{id: 13, name: "Art Blakey"}]}
