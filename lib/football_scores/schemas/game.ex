defmodule FootballScores.Schemas.Game do
  @moduledoc """
  Module defining Ecto schema for games
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias FootballScores.Schemas.{DivisionSeason, Team}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "games" do
    field(:date, :date)
    field(:full_time_home_team_goals, :integer)
    field(:full_time_away_team_goals, :integer)
    field(:full_time_result, :string)
    field(:half_time_home_team_goals, :integer)
    field(:half_time_away_team_goals, :integer)
    field(:half_time_result, :string)
    belongs_to(:home_team, Team)
    belongs_to(:away_team, Team)
    belongs_to(:division_season, DivisionSeason)
  end

  @params [
    :date,
    :full_time_home_team_goals,
    :full_time_away_team_goals,
    :full_time_result,
    :half_time_home_team_goals,
    :half_time_away_team_goals,
    :half_time_result
  ]

  @assocs [
    :division_season,
    :home_team,
    :away_team
  ]

  @required_params @params ++ @assocs

  @spec create_changeset(Game.t(), map(), DivisionSeason.t(), Team.t(), Team.t()) ::
          Ecto.Changeset.t()
  def create_changeset(game, params, division_season, home_team, away_team) do
    game
    |> cast(params, @params)
    |> put_assoc(:division_season, division_season)
    |> put_assoc(:home_team, home_team)
    |> put_assoc(:away_team, away_team)
    |> validate_required(@required_params)
    |> unique_constraint(:date_home_team_id_away_team_id,
      name: :games_date_home_team_id_away_team_id_index
    )
  end
end
