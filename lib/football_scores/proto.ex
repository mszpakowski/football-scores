defmodule FootballScores.Proto do
  @moduledoc """
  Module responsible for defining protobuf message schemas from files
  """

  use Protobuf,
    from: Path.wildcard(Path.expand("./proto/*.proto", __DIR__))
end
