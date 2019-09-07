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

    run _context do
      Brite.Monitor.adjust(:brighten)
    end
  end

  command :darken do
    aliases([:down])
    description("Turns down brightness")

    run _context do
      Brite.Monitor.adjust(:darken)
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
