defmodule FootballScoresWeb.Router do
  use FootballScoresWeb, :router

  alias FootballScoresWeb.{DivisionSeasonController, GameController}

  pipeline :v1 do
    plug :accepts, ["json", "x-protobuf"]
  end

  scope "/v1" do
    pipe_through :v1

    resources "/division_seasons", DivisionSeasonController, only: [:index] do
      resources "/games", GameController, only: [:index]
  end
end
