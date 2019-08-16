defmodule FootballScoresWeb.DivisionSeasonView do
  use FootballScoresWeb, :view

  alias FootballScoresWeb.Schemas.DivisionSeasons.{DivisionSeason, ListDivisionSeasonsResponse}

  def render("division_season.json", %{division_season: division_season}) do
    %DivisionSeason{
      id: division_season.id,
      division: division_season.division,
      season: division_season.season
    }
  end

  def render("division_seasons.json", %{
        division_seasons: %{
          entries: division_seasons,
          page_size: page_size,
          page_number: page_number,
          total_pages: total_pages,
          total_entries: total_entries
        }
      }) do
    %ListDivisionSeasonsResponse{
      division_seasons: render_many(division_seasons, __MODULE__, "division_season.json"),
      page_size: page_size,
      page_number: page_number,
      total_pages: total_pages,
      total_entries: total_entries
    }
  end
end
