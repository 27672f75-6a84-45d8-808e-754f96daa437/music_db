defmodule MusicDB.Repo.Migrations.AddIndexesToCompositions do
  use Ecto.Migration

  def change do
    create index("compositions", :title)
    create index("compositions", :year)
    end
  end


  create index("genres", :name, unique: true)

end
