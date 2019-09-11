defmodule Brite.Ddcctl do
  @moduledoc """
  A module that wraps the ddcctl binary for setting monitor values
  """
  @system Application.get_env(:brite, :system)

  def set(property_name, value) do
    if value < 0 || value > 100 do
      :error
    else
      arg = ddcctl_property_argument(property_name)
      string_value = Integer.to_string(value)
      args = ["-d", "1", arg, string_value]

      case @system.cmd("ddcctl", args) do
        {_, 0} -> :ok
        _ -> :error
      end
    end
  end

  def query(property_name) do
    arg = ddcctl_property_argument(property_name)
    args = ["-d", "1", arg, "\?"]

    case @system.cmd("ddcctl", args) do
      {output, 0} ->
        value = parse_output(output)

        case Integer.parse(value) do
          {int_value, _} ->
            int_value

          :error ->
            :error
        end

      _ ->
        :error
    end
  end

  defp parse_output(output) do
    regex = ~r/current: (?<value>[0-9]+),/
    captures = Regex.named_captures(regex, output)
    captures["value"]
  end

  defp ddcctl_property_argument(property_name) do
    property_name_characters = String.codepoints(property_name)
    first_char_of_name = Enum.at(property_name_characters, 0)
    "-#{first_char_of_name}"
  end
end
