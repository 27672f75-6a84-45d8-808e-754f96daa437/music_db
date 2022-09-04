params = %{"name" => "Thelonius Monk", "birth_date" => "1917-10-10"}
changeset =
  &Artist{}
  |> cast(params, [:name, :birth_date])
  |> validate_required([:name, :birth_date])
  |> validate_length(:name, min: 3)
