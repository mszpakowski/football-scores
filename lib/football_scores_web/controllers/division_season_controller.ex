defmodule FootballScoresWeb.DivisionSeasonController do
  @moduledoc """
  Module defining controller responsible for handling division_seasons resource actions
  """
  use FootballScoresWeb, :controller

  alias FootballScores.{DivisionSeasons, Proto}
  alias FootballScoresWeb.Schemas.DivisionSeasons.ListDivisionSeasonsResponse
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
      summary: "List of division-season pairs",
      description: "List of available division-seasons pairs",
      operationId: "DivisionSeasonController.index",
      parameters: [
        Operation.parameter(:page_number, :query, :integer, "Page to fetch"),
        Operation.parameter(
          :page_size,
          :query,
          :integer,
          "Number of division-season pairs to fetch"
        )
      ],
      responses: %{
        200 =>
          Operation.response("DivisionSeasons", "application/json", ListDivisionSeasonsResponse)
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

  defp handle_protobuf(conn, params) do
    division_seasons =
      [page_size: params[:page_size], page_number: params[:page_number]]
      |> DivisionSeasons.list_protobuf()
      |> Proto.ListDivisionSeasonsResponse.encode()

    conn
    |> put_resp_content_type("application/x-protobuf")
    |> send_resp(200, division_seasons)
  end

  defp handle_json(conn, params) do
    division_seasons =
      DivisionSeasons.list(
        page_size: params[:page_size],
        page_number: params[:page_number]
      )

    conn
    |> put_status(:ok)
    |> render("division_seasons.json", %{division_seasons: division_seasons})
  end
end
