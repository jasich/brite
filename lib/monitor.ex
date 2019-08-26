defmodule Brite.Monitor do
  @system Application.get_env(:brite, :system)

  def adjust(_command) do
    current_brigthness()
  end

  defp current_brigthness do
    {output, return_code} = @system.cmd("ddcctl", ["-d", "1", "-b", "\?"])

    if return_code == 0 do
      captures = Regex.named_captures(~r/current: (?<brightness>[0-9]+),/, output)
      {int_value, _} = Integer.parse(captures["brightness"])
      int_value
    else
      0
    end
  end
end
