defmodule FootballScores.Schemas.DivisionSeason do
  @moduledoc """
  Module defining Ecto schema for division_seasons
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias FootballScores.Schemas.{DivisionParticipation, Game}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "division_seasons" do
    field(:division, :string)
    field(:season, :string)
    has_many(:games, Game)
    has_many(:division_participations, DivisionParticipation)
  end

  @spec create_changeset(DivisionSeason.t(), map()) :: Ecto.Changeset.t()
  def create_changeset(division_season, params) do
    division_season
    |> cast(params, [:division, :season])
    |> validate_required([:division, :season])
    |> unique_constraint(:division_season, name: :division_seasons_division_season_index)
  end
end
