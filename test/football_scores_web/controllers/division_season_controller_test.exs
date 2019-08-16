defmodule FootballScoresWeb.DivisionSeasonControllerTest do
  use FootballScoresWeb.ConnCase

  import ProtoResponse

  alias FootballScores.Proto

  @protobuf_content_type "application/x-protobuf"
  @json_content_type "application/json"

  describe "index/2 with protobuf request" do
    test "responds with protobuf message", %{conn: conn} do
      insert(:division_season)

      response = list_division_seasons(conn, @protobuf_content_type)

      assert %Proto.ListDivisionSeasonsResponse{
               division_seasons: [%Proto.DivisionSeason{id: _, division: _, season: _}]
             } = proto_response(response, 200, Proto.ListDivisionSeasonsResponse)
    end

    test "when no resources returns empty list", %{conn: conn} do
      response = list_division_seasons(conn, @protobuf_content_type)

      assert %Proto.ListDivisionSeasonsResponse{
               division_seasons: []
             } = proto_response(response, 200, Proto.ListDivisionSeasonsResponse)
    end

    test "handles pagination", %{conn: conn} do
      insert(:division_season, division: "La Liga")
      insert(:division_season, division: "Bundesliga")

      response = list_division_seasons(conn, @protobuf_content_type, %{page_size: 1})

      assert %Proto.ListDivisionSeasonsResponse{
               division_seasons: [%Proto.DivisionSeason{division: "Bundesliga"}],
               page_number: 1
             } = proto_response(response, 200, Proto.ListDivisionSeasonsResponse)

      response =
        list_division_seasons(conn, @protobuf_content_type, %{page_size: 1, page_number: 2})

      assert %Proto.ListDivisionSeasonsResponse{
               division_seasons: [%Proto.DivisionSeason{division: "La Liga"}],
               page_number: 2
             } = proto_response(response, 200, Proto.ListDivisionSeasonsResponse)
    end
  end

  describe "index/2 with json request" do
    test "responds with json", %{conn: conn} do
      insert(:division_season)

      response = list_division_seasons(conn, @json_content_type)

      assert %{"division_seasons" => [%{"id" => _, "division" => _, "season" => _}]} =
               json_response(response, 200)
    end

    test "when no resources returns empty list", %{conn: conn} do
      response = list_division_seasons(conn, @json_content_type)
      assert %{"division_seasons" => []} = json_response(response, 200)
    end

    test "handles pagination", %{conn: conn} do
      insert(:division_season, division: "La Liga")
      insert(:division_season, division: "Bundesliga")

      response = list_division_seasons(conn, @json_content_type, %{page_size: 1})

      assert %{"division_seasons" => [%{"division" => "Bundesliga"}], "page_number" => 1} =
               json_response(response, 200)

      response = list_division_seasons(conn, @json_content_type, %{page_size: 1, page_number: 2})

      assert %{"division_seasons" => [%{"division" => "La Liga"}], "page_number" => 2} =
               json_response(response, 200)
    end
  end

  defp list_division_seasons(conn, content_type, params \\ %{}) do
    conn
    |> put_req_header("content-type", content_type)
    |> get(Routes.division_season_path(conn, :index, params))
  end
end
