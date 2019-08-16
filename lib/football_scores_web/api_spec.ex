defmodule FootballScoresWeb.ApiSpec do
  alias OpenApiSpex.{OpenApi, Server, Info, Paths}
  alias FootballScoresWeb.{Endpoint, Router}

  @behaviour OpenApi

  @impl OpenApi

  @spec spec :: OpenApiSpex.OpenApi.t()
  def spec do
    %OpenApi{
      servers: [
        Server.from_endpoint(Endpoint)
      ],
      info: %Info{
        title: "Football Scores API",
        version: "1.0"
      },
      paths: Paths.from_router(Router)
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
