use Mix.Config

config :football_scores, FootballScores.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: 20

port = String.to_integer(System.get_env("PORT") || "4000")

config :football_scores, FootballScoresWeb.Endpoint,
  http: [port: port],
  server: true,
  url: [host: System.get_env("HOSTNAME"), port: port],
  root: ".",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :logger, level: :info
