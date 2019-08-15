defmodule FootballScores.Games do
  @moduledoc """
  Interface module responsible for interacting with game records
  """
  import Ecto.Query, only: [from: 2]

  alias FootballScores.{Proto, Repo}
  alias FootballScores.Schemas.Game

  @doc """
  Fetches paginated games from database
  """
  @spec list(String.t(), Keyword.t() | []) :: Scrivener.Page.t()
  def list(division_season_id, opts \\ []) do
    %{page_number: page_number, page_size: page_size} =
      Enum.into(opts, %{page_number: nil, page_size: nil})

    Repo.paginate(
      from(g in Game,
        join: ht in assoc(g, :home_team),
        join: at in assoc(g, :away_team),
        where: g.division_season_id == ^division_season_id,
        preload: [home_team: ht, away_team: at],
        order_by: [desc: g.date, asc: ht.name, asc: at.name]
      ),
      page: page_number,
      page_size: page_size
    )
  end

  @doc """
  Fetches paginated games from database and casts them to protobuf message schemas
  """
  @spec list_protobuf(String.t(), Keyword.t() | []) :: Proto.ListGamesResponse.t()
  def list_protobuf(division_season_id, opts \\ []) do
    %{page_number: page_number, page_size: page_size} =
      Enum.into(opts, %{page_number: nil, page_size: nil})

    division_season_id
    |> list(page_number: page_number, page_size: page_size)
    |> to_protobuf()
  end

  defp to_protobuf(%Scrivener.Page{
         entries: games,
         page_number: page_number,
         page_size: page_size,
         total_pages: total_pages,
         total_entries: total_entries
       }) do
    Proto.ListGamesResponse.new(%{
      games: Enum.map(games, &to_protobuf/1),
      page_number: page_number,
      page_size: page_size,
      total_pages: total_pages,
      total_entries: total_entries
    })
  end

  defp to_protobuf(%Game{} = game) do
    Proto.Game.new(
      id: game.id,
      date: Date.to_iso8601(game.date),
      full_time_home_team_goals: game.full_time_home_team_goals,
      full_time_away_team_goals: game.full_time_away_team_goals,
      full_time_result: map_result(game.full_time_result),
      half_time_home_team_goals: game.half_time_home_team_goals,
      half_time_away_team_goals: game.half_time_away_team_goals,
      half_time_result: map_result(game.half_time_result),
      home_team: game.home_team.name,
      away_team: game.away_team.name
    )
  end

  defp map_result("H"), do: 1
  defp map_result("D"), do: 2
  defp map_result("A"), do: 3
end
