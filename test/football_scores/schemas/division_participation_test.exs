defmodule FootballScores.Schemas.DivisionParticipationTest do
  use FootballScores.DataCase

  alias FootballScores.{Repo, Schemas.DivisionParticipation}

  describe "create_changeset/3" do
    setup do
      %{
        division_season: insert(:division_season),
        team: insert(:team)
      }
    end

    test "with valid associations creates valid changeset", %{
      division_season: division_season,
      team: team
    } do
      changeset =
        DivisionParticipation.create_changeset(%DivisionParticipation{}, division_season, team)

      assert changeset.valid?
    end

    test "without required association creates invalid changeset", %{
      division_season: division_season
    } do
      changeset =
        DivisionParticipation.create_changeset(%DivisionParticipation{}, division_season, nil)

      refute changeset.valid?
    end

    test "returns error upon insert when unique constraint is violated", %{
      division_season: division_season,
      team: team
    } do
      insert(:division_participation, division_season: division_season, team: team)

      changeset =
        DivisionParticipation.create_changeset(%DivisionParticipation{}, division_season, team)

      assert {:error, _} = Repo.insert(changeset)
    end
  end
end
