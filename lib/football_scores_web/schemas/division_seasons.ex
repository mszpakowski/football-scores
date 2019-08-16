defmodule FootballScoresWeb.Schemas.DivisionSeasons do
  alias OpenApiSpex.Schema

  defmodule DivisionSeason do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Division Season",
      description: "Division-season pair",
      type: :object,
      properties: %{
        id: %Schema{type: :string, description: "Division Season ID"},
        division: %Schema{type: :string, description: "Name of the division"},
        season: %Schema{type: :string, description: "Season span in years"}
      },
      required: [:id, :division, :season],
      example: %{
        "id" => "a73b09e3-b066-4a9b-b4b2-6571392a8017",
        "division" => "SP1",
        "season" => "201819"
      }
    })
  end

  defmodule ListDivisionSeasonsResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Division Seasons",
      description: "Lists multiple division-season pairs",
      type: :object,
      properties: %{
        division_seasons: %Schema{
          type: :array,
          items: DivisionSeason,
          description: "List of division-season paiers"
        },
        page_number: %Schema{type: :integer, description: "Fetched page number"},
        page_size: %Schema{type: :integer, description: "Fetched page size"},
        total_pages: %Schema{type: :integer, description: "Number of pages to fetch"},
        total_entries: %Schema{type: :integer, description: "Total number of records"}
      },
      required: [:division_seasons],
      example: %{
        division_seasons: [
          %{
            "id" => "a73b09e3-b066-4a9b-b4b2-6571392a8017",
            "division" => "SP1",
            "season" => "201819"
          },
          %{
            "id" => "d031d2a3-78d2-4eb5-ad48-188eb68bcb60",
            "division" => "D1",
            "season" => "201819"
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
