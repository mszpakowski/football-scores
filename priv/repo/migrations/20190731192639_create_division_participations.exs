defmodule FootballScores.Repo.Migrations.CreateDivisionParticipations do
  use Ecto.Migration

  def change do
    create table(:division_participations, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:division_season_id, references(:division_seasons, type: :uuid), null: false)
      add(:team_id, references(:teams, type: :uuid), null: false)
    end

    create unique_index(:division_participations, [:division_season_id, :team_id],
             name: :division_participations_division_season_id_team_id_index
           )
  end
end
