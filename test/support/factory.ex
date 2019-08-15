defmodule FootballScores.Factory do
  use ExMachina.Ecto, repo: FootballScores.Repo

  alias FootballScores.Schemas.{DivisionParticipation, DivisionSeason, Game, Team}

  @spec division_season_factory :: DivisionSeason.t()
  def division_season_factory do
    %DivisionSeason{
      division: sequence("division-"),
      season: "2018-2019"
    }
  end

  @spec game_factory :: Game.t()
  def game_factory do
    %Game{
      date: Timex.today(),
      full_time_home_team_goals: 1,
      full_time_away_team_goals: 1,
      full_time_result: "D",
      half_time_home_team_goals: 1,
      half_time_away_team_goals: 1,
      half_time_result: "D",
      home_team: build(:team),
      away_team: build(:team),
      division_season: build(:division_season)
    }
  end

  @spec team_factory :: Team.t()
  def team_factory do
    %Team{
      name: sequence(:name, &"name-#{Integer.to_string(&1) |> String.pad_leading(4, "0")}")
    }
  end

  @spec division_participation_factory :: DivisionParticipation.t()
  def division_participation_factory do
    %DivisionParticipation{
      division_season: build(:division_season),
      team: build(:team)
    }
  end
end
