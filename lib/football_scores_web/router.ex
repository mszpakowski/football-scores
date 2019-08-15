defmodule FootballScoresWeb.Router do
  use FootballScoresWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FootballScoresWeb do
    pipe_through :api
  end
end
