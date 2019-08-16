defmodule FootballScoresWeb.Schemas.Games do
  alias OpenApiSpex.Schema

  defmodule Game do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Game",
      description: "Game details",
      type: :object,
      properties: %{
        id: %Schema{type: :string, description: "Game ID"},
        date: %Schema{type: :sting, format: :date, description: "Date of the game"},
        full_time_home_team_goals: %Schema{
          type: :integer,
          description: "Number of goals scored by the home team at full time"
        },
        full_time_away_team_goals: %Schema{
          type: :integer,
          description: "Number of goals scored by the away team at full time"
        },
        full_time_result: %Schema{
          type: :string,
          enum: ["H", "D", "A"],
          description:
            "Result of the game at full time: H - home team winning, D - draw, A - away team winning"
        },
        half_time_home_team_goals: %Schema{
          type: :integer,
          description: "Number of goals scored by the home team at half time"
        },
        half_time_away_team_goals: %Schema{
          type: :integer,
          description: "Number of goals scored by the away team at half time"
        },
        half_time_result: %Schema{
          type: :string,
          enum: ["H", "D", "A"],
          description:
            "Result of the game at half time: H - home team leading, D - draw, A - away team leading"
        },
        home_team: %Schema{type: :string, description: "Home team name"},
        away_team: %Schema{type: :string, description: "Away team name"}
      },
      required: [
        :id,
        :date,
        :full_time_home_team_goals,
        :full_time_away_team_goals,
        :full_time_result,
        :half_time_home_team_goals,
        :half_time_away_team_goals,
        :half_time_result,
        :home_team,
        :away_team
      ],
      example: %{
        "id" => "470073d2-664b-4331-b101-5f360a3d6e19",
        "date" => "2016-08-19",
        "full_time_home_team_goals" => 2,
        "full_time_away_team_goals" => 1,
        "full_time_result" => "H",
        "half_time_home_team_goals" => 0,
        "half_time_away_team_goals" => 0,
        "half_time_result" => "D",
        "home_team" => "La Coruna",
        "away_team" => "Eibar"
      }
    })
  end

  defmodule ListGamesResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Games",
      description: "List of games in given division and season",
      type: :object,
      properties: %{
        games: %Schema{
          type: :array,
          items: Game,
          description: "List of games in given division and season"
        },
        page_number: %Schema{type: :integer, description: "Fetched page number"},
        page_size: %Schema{type: :integer, description: "Fetched page size"},
        total_pages: %Schema{type: :integer, description: "Number of pages to fetch"},
        total_entries: %Schema{type: :integer, description: "Total number of records"}
      },
      required: [:games],
      example: %{
        games: [
          %{
            "id" => "470073d2-664b-4331-b101-5f360a3d6e19",
            "date" => "2016-08-19",
            "full_time_home_team_goals" => 2,
            "full_time_away_team_goals" => 1,
            "full_time_result" => "H",
            "half_time_home_team_goals" => 0,
            "half_time_away_team_goals" => 0,
            "half_time_result" => "D",
            "home_team" => "La Coruna",
            "away_team" => "Eibar"
          },
          %{
            "id" => "e43ed0f2-2199-44a9-9409-1a040b665103",
            "date" => "2016-08-19",
            "full_time_home_team_goals" => 1,
            "full_time_away_team_goals" => 1,
            "full_time_result" => "D",
            "half_time_home_team_goals" => 0,
            "half_time_away_team_goals" => 0,
            "half_time_result" => "D",
            "home_team" => "Malaga",
            "away_team" => "Osasuna"
          }
        ],
        page_number: 1,
        page_size: 100,
        total_pages: 10,
        total_entries: 1000
      }
    })
  end
end
