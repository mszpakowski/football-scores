defmodule FootballScores.Repo.Migrations.CreateDivisionSeasons do
  use Ecto.Migration

  def change do
    create table(:division_seasons, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:division, :string, null: false)
      add(:season, :string, null: false)
    end

    create unique_index(:division_seasons, [:division, :season],
             name: :division_seasons_division_season_index
           )
  end
end
