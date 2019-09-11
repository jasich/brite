defmodule Brite.BriteCLI do
  @moduledoc """
  Brite is an executable for increasing/decreasing monitor brightness.
  """
  use ExCLI.DSL, escript: true

  name("brite")
  description("Increase/Decrease monitor brightness")

  command :brighten do
    aliases([:up])
    description("Turns up brightness")

    option(:value, required: false, type: :integer, default: nil, aliases: [:v])

    run context do
      if Map.has_key?(context, :value) do
        Brite.Monitor.brighten(context.value)
      else
        Brite.Monitor.brighten()
      end
    end
  end

  command :darken do
    aliases([:down])
    description("Turns down brightness")

    option(:value, required: false, type: :integer, default: nil, aliases: [:v])

    run context do
      if Map.has_key?(context, :value) do
        Brite.Monitor.darken(context.value)
      else
        Brite.Monitor.darken()
      end
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

  command :set do
    description("Sets the brightness and contrast directly")

    argument(:brightness, type: :integer, default: nil)
    argument(:contrast, type: :integer, default: nil)

    run context do
      Brite.Monitor.set(context.brightness, context.contrast)
    end
  end
end
