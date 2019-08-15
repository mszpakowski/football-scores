defmodule FootballScores.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string, null: false)
    end

    create unique_index(:teams, [:name], name: :teams_name_index)
  end
end
