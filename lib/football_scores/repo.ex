defmodule FootballScores.Repo do
  use Ecto.Repo,
    otp_app: :football_scores,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 100
end
