use Mix.Config

config :serverlex, Serverlex.Repo,
  username: "postgres",
  password: "",
  database: "serverlex_repo_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
