defmodule FootballScores.DatabaseSeeder do
  @moduledoc """
  Module responsible for seeding the database from CSV file
  """

  alias FootballScores.Repo
  alias FootballScores.Schemas.{DivisionParticipation, DivisionSeason, Game, Team}
  alias NimbleCSV.RFC4180, as: CSV

  @division_map %{
    "SP1" => "La Liga",
    "SP2" => "Segunda Division",
    "E0" => "Premier League",
    "D1" => "Bundesliga"
  }

  @doc """
  Function responsible for streaming game data from CSV
  and seeding the database
  """
  @spec run :: :ok
  def run do
    Repo.transaction(
      fn ->
        Application.app_dir(:football_scores, "priv/repo/data.csv")
        |> File.stream!()
        |> CSV.parse_stream()
        |> Stream.map(&insert_into_database/1)
        |> Stream.run()
      end,
      timeout: :infinity
    )
  end

  defp insert_into_database([
         _number,
         division,
         season,
         date,
         home_team,
         away_team,
         full_time_home_team_goals,
         full_time_away_team_goals,
         full_time_result,
         half_time_home_team_goals,
         half_time_away_team_goals,
         half_time_result
       ]) do
    {:ok, division_season} = find_or_create_division_season(division, season)
    {:ok, home_team} = find_or_create_team(home_team)
    {:ok, away_team} = find_or_create_team(away_team)

    create_division_participation(division_season, home_team)
    create_division_participation(division_season, away_team)

    create_game(
      date,
      full_time_home_team_goals,
      full_time_away_team_goals,
      full_time_result,
      half_time_home_team_goals,
      half_time_away_team_goals,
      half_time_result,
      division_season,
      home_team,
      away_team
    )
  end

  defp find_or_create_division_season(division, season) do
    division = @division_map[division]
    season = parse_season(season)

    case Repo.get_by(DivisionSeason, division: division, season: season) do
      nil ->
        %DivisionSeason{}
        |> DivisionSeason.create_changeset(%{
          division: division,
          season: season
        })
        |> Repo.insert()

      %DivisionSeason{} = division_season ->
        {:ok, division_season}
    end
  end

  defp find_or_create_team(name) do
    case Repo.get_by(Team, name: name) do
      nil ->
        %Team{}
        |> Team.create_changeset(%{name: name})
        |> Repo.insert()

      %Team{} = team ->
        {:ok, team}
    end
  end

  defp create_division_participation(division_season, team) do
    %DivisionParticipation{}
    |> DivisionParticipation.create_changeset(division_season, team)
    |> Repo.insert(on_conflict: :nothing)
  end

  defp create_game(
         date,
         full_time_home_team_goals,
         full_time_away_team_goals,
         full_time_result,
         half_time_home_team_goals,
         half_time_away_team_goals,
         half_time_result,
         division_season,
         home_team,
         away_team
       ) do
    %Game{}
    |> Game.create_changeset(
      %{
        date: Timex.parse!(date, "{D}/{0M}/{YYYY}"),
        full_time_home_team_goals: full_time_home_team_goals,
        full_time_away_team_goals: full_time_away_team_goals,
        full_time_result: full_time_result,
        half_time_home_team_goals: half_time_home_team_goals,
        half_time_away_team_goals: half_time_away_team_goals,
        half_time_result: half_time_result
      },
      division_season,
      home_team,
      away_team
    )
    |> Repo.insert(on_conflict: :nothing)
  end

  defp parse_season(<<year1::8*4, year2::binary>>), do: <<year1::8*4, "-20", year2::binary>>
end
