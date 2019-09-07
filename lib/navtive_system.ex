defmodule Brite.NativeSystem do
  @moduledoc """
  A wrapper around the Native system command.
  """

  @behaviour Brite.Systemable

  @impl Brite.Systemable
  def cmd(command, args) do
    System.cmd(command, args)
  end
end
