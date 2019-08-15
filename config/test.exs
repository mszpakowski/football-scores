use Mix.Config

# Configure your database
config :football_scores, FootballScores.Repo,
  url: System.get_env("DATABASE_URL_TEST"),
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :football_scores, FootballScoresWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
