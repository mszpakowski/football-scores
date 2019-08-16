defmodule FootballScoresWeb.GameController do
  @moduledoc """
  Module defining controller responsible for handling games resource actions
  """
  use FootballScoresWeb, :controller

  alias FootballScores.{Games, Proto}
  alias FootballScoresWeb.Schemas.Games.ListGamesResponse
  alias OpenApiSpex.Operation

  plug OpenApiSpex.Plug.CastAndValidate

  @spec open_api_operation(:index) :: Operation.t()
  def open_api_operation(:index) do
    apply(__MODULE__, :index_operation, [])
  end

  @spec index_operation() :: Operation.t()
  def index_operation() do
    %Operation{
      tags: ["division_seasons"],
      summary: "List of games",
      description: "List of games for given division and season",
      operationId: "GameController.index",
      parameters: [
        Operation.parameter(:division_season_id, :path, :string, "Division Season ID"),
        Operation.parameter(:page_number, :query, :integer, "Page to fetch"),
        Operation.parameter(
          :page_size,
          :query,
          :integer,
          "Number of games to fetch"
        )
      ],
      responses: %{
        200 => Operation.response("Games", "application/json", ListGamesResponse)
      }
    }
  end

  @doc """
  Function handling index action. Checks request's content-type and serves
  protobuf or json response accordingly
  """
  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    case get_req_header(conn, "content-type") do
      ["application/json" <> _] ->
        handle_json(conn, params)

      ["application/x-protobuf" <> _] ->
        handle_protobuf(conn, params)

      _ ->
        send_resp(400, conn, "")
    end
  end

  defp handle_protobuf(conn, %{division_season_id: division_season_id} = params) do
    games =
      division_season_id
      |> Games.list_protobuf(page_size: params[:page_size], page_number: params[:page_number])
      |> Proto.ListGamesResponse.encode()

    conn
    |> put_resp_content_type("application/x-protobuf")
    |> send_resp(200, games)
  end

  defp handle_json(conn, %{division_season_id: division_season_id} = params) do
    games =
      FootballScores.Games.list(division_season_id,
        page_size: params[:page_size],
        page_number: params[:page_number]
      )

    conn
    |> put_status(:ok)
    |> render("games.json", %{games: games})
  end
end
