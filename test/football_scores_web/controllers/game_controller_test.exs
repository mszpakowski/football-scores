defmodule FootballScoresWeb.GameControllerTest do
  use FootballScoresWeb.ConnCase

  import ProtoResponse

  alias FootballScores.Proto

  @protobuf_content_type "application/x-protobuf"
  @json_content_type "application/json"

  setup do
    %{division_season: insert(:division_season)}
  end

  describe "index/2 with protobuf request" do
    test "responds with protobuf message", %{conn: conn, division_season: division_season} do
      insert(:game, division_season: division_season)

      response = list_games(conn, @protobuf_content_type, division_season.id)

      assert %Proto.ListGamesResponse{
               games: [%Proto.Game{}]
             } = proto_response(response, 200, Proto.ListGamesResponse)
    end

    test "when no resources returns empty list", %{conn: conn, division_season: division_season} do
      response = list_games(conn, @protobuf_content_type, division_season.id)

      assert %Proto.ListGamesResponse{
               games: []
             } = proto_response(response, 200, Proto.ListGamesResponse)
    end

    test "handles pagination", %{conn: conn, division_season: division_season} do
      %{id: game_one_id} = insert(:game, division_season: division_season)
      %{id: game_two_id} = insert(:game, division_season: division_season)

      response = list_games(conn, @protobuf_content_type, division_season.id, %{page_size: 1})

      assert %Proto.ListGamesResponse{
               games: [%Proto.Game{id: ^game_one_id}],
               page_number: 1
             } = proto_response(response, 200, Proto.ListGamesResponse)

      response =
        list_games(conn, @protobuf_content_type, division_season.id, %{
          page_size: 1,
          page_number: 2
        })

      assert %Proto.ListGamesResponse{
               games: [%Proto.Game{id: ^game_two_id}],
               page_number: 2
             } = proto_response(response, 200, Proto.ListGamesResponse)
    end
  end

  describe "index/2 with json request" do
    test "responds with json", %{conn: conn, division_season: division_season} do
      insert(:game, division_season: division_season)

      response = list_games(conn, @json_content_type, division_season.id)

      assert %{"games" => [%{"id" => _, "full_time_result" => _}]} = json_response(response, 200)
    end

    test "when no resources returns empty list", %{conn: conn, division_season: division_season} do
      response = list_games(conn, @json_content_type, division_season.id)
      assert %{"games" => []} = json_response(response, 200)
    end

    test "handles pagination", %{conn: conn, division_season: division_season} do
      %{id: game_one_id} = insert(:game, division_season: division_season)
      %{id: game_two_id} = insert(:game, division_season: division_season)

      response = list_games(conn, @json_content_type, division_season.id, %{page_size: 1})

      assert %{"games" => [%{"id" => ^game_one_id}], "page_number" => 1} =
               json_response(response, 200)

      response =
        list_games(conn, @json_content_type, division_season.id, %{page_size: 1, page_number: 2})

      assert %{"games" => [%{"id" => ^game_two_id}], "page_number" => 2} =
               json_response(response, 200)
    end
  end

  defp list_games(conn, content_type, division_season_id, params \\ %{}) do
    conn
    |> put_req_header("content-type", content_type)
    |> get(Routes.division_season_game_path(conn, :index, division_season_id, params))
  end
end
