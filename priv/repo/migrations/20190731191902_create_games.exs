defmodule FootballScores.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:date, :date, null: false)
      add(:full_time_home_team_goals, :integer, null: false)
      add(:full_time_away_team_goals, :integer, null: false)
      add(:full_time_result, :string, null: false)
      add(:half_time_home_team_goals, :integer, null: false)
      add(:half_time_away_team_goals, :integer, null: false)
      add(:half_time_result, :string, null: false)
      add(:home_team_id, references(:teams, type: :uuid), null: false)
      add(:away_team_id, references(:teams, type: :uuid), null: false)
      add(:division_season_id, references(:division_seasons, type: :uuid), null: false)
    end

    create unique_index(:games, [:date, :home_team_id, :away_team_id],
             name: :games_date_home_team_id_away_team_id_index
           )
  end
end
