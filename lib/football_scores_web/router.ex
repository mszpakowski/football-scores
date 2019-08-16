defmodule FootballScoresWeb.Router do
  use FootballScoresWeb, :router

  alias FootballScoresWeb.{DivisionSeasonController, GameController, ProtodocController}

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :v1 do
    plug :accepts, ["json", "x-protobuf"]
    plug OpenApiSpex.Plug.PutApiSpec, module: FootballScoresWeb.ApiSpec
  end

  scope "/" do
    pipe_through :browser

    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/v1/openapi"
    get "/protodoc", ProtodocController, :index
  end

  scope "/v1" do
    pipe_through :v1

    resources "/division_seasons", DivisionSeasonController, only: [:index] do
      resources "/games", GameController, only: [:index]
    end

    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end
end
