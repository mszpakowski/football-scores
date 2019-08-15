defmodule FootballScores.Schemas.GameTest do
  use FootballScores.DataCase

  alias FootballScores.{Repo, Schemas.Game}

  describe "create_changeset/5" do
    setup do
      params = %{
        date: ~D[2019-04-01],
        full_time_home_team_goals: 1,
        full_time_away_team_goals: 1,
        full_time_result: "D",
        half_time_home_team_goals: 0,
        half_time_away_team_goals: 0,
        half_time_result: "D"
      }

      %{
        params: params,
        division_season: insert(:division_season),
        home_team: insert(:team),
        away_team: insert(:team)
      }
    end

    test "with valid params creates valid changeset", %{
      params: params,
      division_season: division_season,
      home_team: home_team,
      away_team: away_team
    } do
      changeset = Game.create_changeset(%Game{}, params, division_season, home_team, away_team)
      assert changeset.valid?
    end

    test "without required fields creates invalid changeset", %{
      division_season: division_season,
      home_team: home_team,
      away_team: away_team
    } do
      params = %{date: "2018-01-01"}
      changeset = Game.create_changeset(%Game{}, params, division_season, home_team, away_team)
      refute changeset.valid?
    end

    test "returns error tuple upon insert when unique constraint is violated", %{
      params: params,
      division_season: division_season,
      home_team: home_team,
      away_team: away_team
    } do
      insert(:game, date: params.date, home_team: home_team, away_team: away_team)
      changeset = Game.create_changeset(%Game{}, params, division_season, home_team, away_team)
      assert {:error, _} = Repo.insert(changeset)
    end
  end
end
