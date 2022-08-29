q = from(a in "artists", [{:where, fragment("lower(?)", a.name) == "miles davis"},{:select, [:id, :name]}])
