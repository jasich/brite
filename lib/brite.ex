defmodule Brite do
  @moduledoc """
  Brite is an executable for increasing/decreasing monitor brightness.
  """
  use ExCLI.DSL, escript: true

  name("brite")
  description("Increase/Decrease monitor brightness")

  command :brighten do
    aliases([:up])
    description("Turns up brightness")

    argument(:value, type: :integer, default: nil)

    run context do
      Brite.Monitor.brighten(context.value)
    end
  end

  command :darken do
    aliases([:down])
    description("Turns down brightness")

    argument(:value, type: :integer, default: nil)

    run context do
      Brite.Monitor.darken(context.value)
    end
  end

  command :cur do
    description("Queries current value")

    run _context do
      brightness = Brite.Monitor.query(:brightness)
      contrast = Brite.Monitor.query(:contrast)

      IO.puts("Brightness: #{brightness}, Contrast: #{contrast}")
    end
  end
end
