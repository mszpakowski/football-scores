defmodule FootballScores.Schemas.Team do
  @moduledoc """
  Module defining Ecto schema for teams
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias FootballScores.Schemas.{DivisionParticipation, Game}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "teams" do
    field(:name, :string)
    has_many(:home_games, Game, foreign_key: :home_team_id)
    has_many(:away_games, Game, foreign_key: :away_team_id)
    has_many(:division_participations, DivisionParticipation)
    has_many(:division_seasons, through: [:division_participations, :division_season])
  end

  @spec create_changeset(Team.t(), map()) :: Ecto.Changeset.t()
  def create_changeset(team, params) do
    team
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
