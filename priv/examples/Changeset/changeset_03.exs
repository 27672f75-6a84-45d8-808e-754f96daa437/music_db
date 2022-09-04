# values provided by the user
params = %{"name" => "Charlie Parker", "birth_date" => "1920-08-29",
"instrument" => "alto sax"}

changeset = cast(%Artist{}, params, [:name, :birth_date])
changeset.changes
#=> %{birth_date: ~D[1920-08-29], name: "Charlie Parker"}
