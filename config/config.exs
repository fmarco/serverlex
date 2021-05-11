import Config


import_config "#{Mix.env()}.exs"
config :serverlex, ecto_repos: [Serverlex.Repo]
