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

    case @system.cmd("ddcctl", args) do
      {_, 0} -> :ok
      _ -> :error
    end
  end

  def query(:brightness), do: query_integer("brightness")
  def query(:contrast), do: query_integer("contrast")

  defp query_integer(property_name) do
    case query_helper(property_name) do
      {:ok, value} ->
        case Integer.parse(value) do
          {int_value, _} ->
            int_value

          :error ->
            :error
        end

      {:error} ->
        :error
    end
  end

  defp query_helper(property_name) do
    first_char_of_name = Enum.at(String.codepoints(property_name), 0)
    args = ["-d", "1", "-#{first_char_of_name}", "\?"]
    {output, return_code} = @system.cmd("ddcctl", args)

    regex = ~r/current: (?<value>[0-9]+),/

    if return_code == 0 do
      captures = Regex.named_captures(regex, output)
      {:ok, captures["value"]}
    else
      {:error}
    end
  end
end
