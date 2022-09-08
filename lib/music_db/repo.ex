defmodule MusicDB.Repo do
  use Ecto.Repo,
    otp_app: :music_db,
    adapter: Ecto.Adapters.Postgres

  def using_postgres? do
    MusicDB.Repo.__adapter__() == Ecto.Adapters.Postgres
  end
end
