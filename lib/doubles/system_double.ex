defmodule Brite.SystemDouble do
  def cmd(_command, args) do
    if brightness_query?(args) do
      {"current: 85,", 0}
    else
      {"", 1}
    end
  end

  defp brightness_query?(args) do
    List.last(args) == "?"
  end
end
