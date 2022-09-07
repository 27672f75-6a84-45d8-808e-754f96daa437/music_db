import Config

config :music_db, ecto_repos: [MusicDB.Repo]

config :music_db, MusicDB.Repo,
  database: "music_db_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  # migration_primary_key: [id: :code, type: :string],
  pool: Ecto.Adapters.SQL.Sandbox,
  port: 15432
