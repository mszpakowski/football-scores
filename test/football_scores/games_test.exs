defmodule FootballScores.GamesTest do
  use FootballScores.DataCase

  alias FootballScores.{Games, Proto, Schemas.Game}

  setup do
    %{division_season: insert(:division_season)}
  end

  describe "list/1" do
    test "returns list of division seasons", %{division_season: division_season} do
      insert_list(3, :game, division_season: division_season)

      assert %{entries: [%Game{}, %Game{}, %Game{}]} = Games.list(division_season.id)
    end

    test "lists only games belonging to specific division season", %{
      division_season: division_season
    } do
      insert_list(3, :game, division_season: division_season)
      %{id: other_division_game_id, division_season_id: other_division_season_id} = insert(:game)

      assert %{entries: [%Game{id: ^other_division_game_id}]} =
               Games.list(other_division_season_id)
    end

    test "returns empty list if no games for specific division-season", %{
      division_season: division_season
    } do
      insert_list(3, :game, division_season: division_season)
      %{id: other_division_season_id} = insert(:division_season)

      assert %{entries: []} = Games.list(other_division_season_id)
    end

    test "handles pagination", %{division_season: division_season} do
      insert_list(3, :game, division_season: division_season)

      assert %{
               total_entries: 3,
               page_size: 2,
               total_pages: 2,
               page_number: 1,
               entries: [%Game{}, %Game{}]
             } = Games.list(division_season.id, page_number: 1, page_size: 2)
    end
  end

  describe "list_protobuf/1" do
    test "returns list of division seasons protobuf structs", %{division_season: division_season} do
      insert_list(3, :game, division_season: division_season)

      assert %Proto.ListGamesResponse{
               games: [
                 %Proto.Game{},
                 %Proto.Game{},
                 %Proto.Game{}
               ]
             } = Games.list_protobuf(division_season.id)
    end

    test "lists only games belonging to specific division season", %{
      division_season: division_season
    } do
      insert_list(3, :game, division_season: division_season)
      %{id: other_division_game_id, division_season_id: other_division_season_id} = insert(:game)

      assert %Proto.ListGamesResponse{games: [%Proto.Game{id: ^other_division_game_id}]} =
               Games.list_protobuf(other_division_season_id)
    end

    test "returns empty list if no games for specific division-season", %{
      division_season: division_season
    } do
      insert_list(3, :game, division_season: division_season)
      %{id: other_division_season_id} = insert(:division_season)

      assert %Proto.ListGamesResponse{games: []} = Games.list_protobuf(other_division_season_id)
    end

    test "handles pagination", %{division_season: division_season} do
      insert(:game, date: ~D[2019-04-01], division_season: division_season)
      insert(:game, date: ~D[2019-04-02], division_season: division_season)
      insert(:game, date: ~D[2019-04-03], division_season: division_season)

      assert %Proto.ListGamesResponse{
               games: [
                 %Proto.Game{date: "2019-04-03"},
                 %Proto.Game{date: "2019-04-02"}
               ],
               total_entries: 3,
               page_size: 2,
               total_pages: 2,
               page_number: 1
             } = Games.list_protobuf(division_season.id, page_number: 1, page_size: 2)

      assert %Proto.ListGamesResponse{
               games: [
                 %Proto.Game{date: "2019-04-01"}
               ],
               total_entries: 3,
               page_size: 2,
               total_pages: 2,
               page_number: 2
             } = Games.list_protobuf(division_season.id, page_number: 2, page_size: 2)
    end
  end
end
