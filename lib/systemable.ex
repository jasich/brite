defmodule Brite.Systemable do
  @moduledoc """
  Behavior for calling system commands.
  """

  @callback cmd(String.t(), [String.t()]) :: {String.t(), number}
end
