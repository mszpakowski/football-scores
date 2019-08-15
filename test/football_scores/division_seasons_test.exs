defmodule FootballScores.DivisionSeasonsTest do
  use FootballScores.DataCase

  alias FootballScores.{DivisionSeasons, Proto, Schemas.DivisionSeason}

  describe "list/1" do
    test "returns list of division seasons" do
      insert_list(3, :division_season)

      assert %{entries: [%DivisionSeason{}, %DivisionSeason{}, %DivisionSeason{}]} =
               DivisionSeasons.list()
    end

    test "handles pagination" do
      insert_list(3, :division_season)

      assert %{
               total_entries: 3,
               page_size: 2,
               total_pages: 2,
               page_number: 1,
               entries: [%DivisionSeason{}, %DivisionSeason{}]
             } = DivisionSeasons.list(page: 1, page_size: 2)
    end
  end

  describe "list_protobuf/1" do
    test "returns list of division seasons protobuf structs" do
      insert_list(3, :division_season)

      assert %Proto.ListDivisionSeasonsResponse{
               division_seasons: [
                 %Proto.DivisionSeason{},
                 %Proto.DivisionSeason{},
                 %Proto.DivisionSeason{}
               ]
             } = DivisionSeasons.list_protobuf()
    end

    test "handles pagination" do
      insert(:division_season, division: "La Liga")
      insert(:division_season, division: "Bundesliga")
      insert(:division_season, division: "Premier League")

      assert %Proto.ListDivisionSeasonsResponse{
               division_seasons: [
                 %Proto.DivisionSeason{division: "Bundesliga"},
                 %Proto.DivisionSeason{division: "La Liga"}
               ],
               total_entries: 3,
               page_size: 2,
               total_pages: 2,
               page_number: 1
             } = DivisionSeasons.list_protobuf(page_number: 1, page_size: 2)

      assert %Proto.ListDivisionSeasonsResponse{
               division_seasons: [
                 %Proto.DivisionSeason{division: "Premier League"}
               ],
               total_entries: 3,
               page_size: 2,
               total_pages: 2,
               page_number: 2
             } = DivisionSeasons.list_protobuf(page_number: 2, page_size: 2)
    end
  end
end
