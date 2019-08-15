defmodule FootballScores.DivisionSeasons do
  @moduledoc """
  Interface module responsible for interacting with division_seasons records
  """
  import Ecto.Query, only: [from: 2]

  alias FootballScores.{Proto, Repo}
  alias FootballScores.Schemas.DivisionSeason

  @doc """
  Fetches paginated division_seasons from database
  """
  @spec list(Keyword.t() | []) :: Scrivener.Page.t()
  def list(opts \\ []) do
    %{page_number: page_number, page_size: page_size} =
      Enum.into(opts, %{page_number: nil, page_size: nil})

    Repo.paginate(
      from(ds in DivisionSeason,
        order_by: [desc: ds.season, asc: ds.division]
      ),
      page: page_number,
      page_size: page_size
    )
  end

  @doc """
  Fetches paginated division_seasons from database and casts them to protobuf message schemas
  """
  @spec list_protobuf(Keyword.t() | []) :: Proto.ListDivisionSeasons.Response.t()
  def list_protobuf(opts \\ []) do
    %{page_number: page_number, page_size: page_size} =
      Enum.into(opts, %{page_number: nil, page_size: nil})

    [page_number: page_number, page_size: page_size]
    |> list()
    |> to_protobuf()
  end

  defp to_protobuf(%Scrivener.Page{
         entries: division_seasons,
         page_number: page_number,
         page_size: page_size,
         total_pages: total_pages,
         total_entries: total_entries
       }) do
    Proto.ListDivisionSeasonsResponse.new(%{
      division_seasons: Enum.map(division_seasons, &to_protobuf/1),
      page_number: page_number,
      page_size: page_size,
      total_pages: total_pages,
      total_entries: total_entries
    })
  end

  defp to_protobuf(%DivisionSeason{id: id, division: division, season: season}) do
    Proto.DivisionSeason.new(id: id, division: division, season: season)
  end
end
