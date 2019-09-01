defmodule Brite.Monitor do
  @system Application.get_env(:brite, :system)
  @adjust_step 5

  def adjust(:brighten) do
    new_brightness = query(:brightness) + @adjust_step
    new_contrast = query(:contrast) + @adjust_step

    set_values(new_brightness, new_contrast)
  end

  def adjust(:lighten) do
    new_brightness = query(:brightness) - @adjust_step
    new_contrast = query(:contrast) - @adjust_step

    set_values(new_brightness, new_contrast)
  end

  defp set_values(brightness, contrast) do
    args = [
      "-d",
      "1",
      "-c",
      Integer.to_string(contrast),
      "-b",
      Integer.to_string(brightness)
    ]

    {_, return_code} = @system.cmd("ddcctl", args)

    if return_code == 0 do
      :ok
    else
      :error
    end
  end

  def query(:brightness) do
    execute_query(
      ["-d", "1", "-b", "\?"],
      ~r/current: (?<brightness>[0-9]+),/,
      "brightness"
    )
  end

  def query(:contrast) do
    execute_query(
      ["-d", "1", "-c", "\?"],
      ~r/current: (?<contrast>[0-9]+),/,
      "contrast"
    )
  end

  defp execute_query(args, regex, capture_name) do
    {output, return_code} = @system.cmd("ddcctl", args)

    if return_code == 0 do
      captures = Regex.named_captures(regex, output)
      {int_value, _} = Integer.parse(captures[capture_name])
      int_value
    else
      0
    end
  end
end
