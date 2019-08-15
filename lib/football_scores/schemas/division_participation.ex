defmodule FootballScores.Schemas.DivisionParticipation do
  @moduledoc """
  Module defining Ecto schema for division_participations
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias FootballScores.Schemas.{DivisionSeason, Team}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "division_participations" do
    belongs_to(:division_season, DivisionSeason)
    belongs_to(:team, Team)
  end

  @spec create_changeset(DivisionParticipation.t(), DivisionSeason.t(), Team.t()) ::
          Ecto.Changeset.t()
  def create_changeset(division_participation, division_season, team) do
    division_participation
    |> cast(%{}, [])
    |> put_assoc(:division_season, division_season)
    |> put_assoc(:team, team)
    |> validate_required([:division_season, :team])
    |> unique_constraint(:division_season_team,
      name: :division_participations_division_season_id_team_id_index
    )
  end
end
