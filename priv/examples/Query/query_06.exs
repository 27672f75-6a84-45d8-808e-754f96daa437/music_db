# like statements
q = from(artist in "artists", [{:where, like(artist.name , "Miles%")}, {:select, [:id, :name]}])

# checking for null
q = from(artist in "artists", [{:where , is_nil(artist.name)},{:select, [:id, :name]}])

# checking for not null
q = from( artist in "artists", [{:where, not is_nil(artist.name)}, {:select, [:id,:name]}] )
