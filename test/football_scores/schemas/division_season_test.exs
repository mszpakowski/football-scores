defmodule FootballScores.Schemas.DivisionSeasonTest do
  use FootballScores.DataCase

  alias FootballScores.{Repo, Schemas.DivisionSeason}

  describe "create_changeset/2" do
    setup do
      %{params: %{division: "La Liga", season: "2018-2019"}}
    end

    test "with valid params creates valid changeset", %{params: params} do
      changeset = DivisionSeason.create_changeset(%DivisionSeason{}, params)
      assert changeset.valid?
    end

    test "without required fields creates invalid changeset" do
      params = %{division: "La Liga"}
      changeset = DivisionSeason.create_changeset(%DivisionSeason{}, params)
      refute changeset.valid?
    end

    test "returns error upon insert when unique constraint is violated", %{params: params} do
      insert(:division_season, division: "La Liga", season: "2018-2019")
      changeset = DivisionSeason.create_changeset(%DivisionSeason{}, params)
      assert {:error, _} = Repo.insert(changeset)
    end
  end
end
