defmodule FootballScoresWeb.ProtodocController do
  @moduledoc """
  Module defining controller responsible for serving protobuf documentation
  """
  use FootballScoresWeb, :controller

  @doc """
  Serves static page with protodoc documentation
  """
  def index(conn, _params) do
    conn
    |> put_resp_content_type("text/html")
    |> send_file(200, Application.app_dir(:football_scores, "priv/protodoc/index.html"))
  end
end
