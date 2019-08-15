defmodule FootballScores.Schemas.TeamTest do
  use FootballScores.DataCase

  alias FootballScores.{Repo, Schemas.Team}

  describe "create_changeset/2" do
    setup do
      %{
        params: %{name: "Barcelona"}
      }
    end

    test "with valid associations creates valid changeset", %{params: params} do
      changeset = Team.create_changeset(%Team{}, params)

      assert changeset.valid?
    end

    test "with invalid params creates invalid changeset" do
      changeset = Team.create_changeset(%Team{}, %{})

      refute changeset.valid?
    end

    test "returns error upon insert when unique constraint is violated", %{params: params} do
      insert(:team, name: "Barcelona")

      changeset = Team.create_changeset(%Team{}, params)

      assert {:error, _} = Repo.insert(changeset)
    end
  end
end
