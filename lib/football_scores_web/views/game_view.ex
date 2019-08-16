defmodule FootballScoresWeb.GameView do
  use FootballScoresWeb, :view

  alias FootballScoresWeb.Schemas.Games.{Game, ListGamesResponse}

  def render("game.json", %{game: game}) do
    %Game{
      id: game.id,
      date: game.date,
      full_time_home_team_goals: game.full_time_home_team_goals,
      full_time_away_team_goals: game.full_time_away_team_goals,
      full_time_result: game.full_time_result,
      half_time_home_team_goals: game.half_time_home_team_goals,
      half_time_away_team_goals: game.half_time_away_team_goals,
      half_time_result: game.half_time_result,
      home_team: game.home_team.name,
      away_team: game.away_team.name
    }
  end

  def render("games.json", %{
        games: %{
          entries: games,
          page_size: page_size,
          page_number: page_number,
          total_pages: total_pages,
          total_entries: total_entries
        }
      }) do
    %ListGamesResponse{
      games: render_many(games, __MODULE__, "game.json"),
      page_size: page_size,
      page_number: page_number,
      total_pages: total_pages,
      total_entries: total_entries
    }
  end
end
