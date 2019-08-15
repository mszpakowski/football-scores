defmodule FootballScores.Repo do
  use Ecto.Repo,
    otp_app: :football_scores,
    adapter: Ecto.Adapters.Postgres
end
