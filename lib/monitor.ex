defmodule Brite.Monitor do
  @system Application.get_env(:brite, :system)
  @adjust_step 5

  def adjust(:brighten) do
    new_brightness = query(:brightness) + @adjust_step
    execute_ddcctl_set("brightness", new_brightness)

    new_contrast = query(:contrast) + @adjust_step
    execute_ddcctl_set("contrast", new_contrast)
  end

  def adjust(:lighten) do
    new_brightness = query(:brightness) - @adjust_step
    execute_ddcctl_set("brightness", new_brightness)

    new_contrast = query(:contrast) - @adjust_step
    execute_ddcctl_set("contrast", new_contrast)
  end

  defp execute_ddcctl_set(property_name, value) do
    arg = ddcctl_property_argument(property_name)
    string_value = Integer.to_string(value)
    args = ["-d", "1", arg, string_value]

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

      :error ->
        :error
    end
  end

  defp query_helper(property_name) do
    case execute_ddcctl_query(property_name) do
      :error ->
        :error

      output ->
        regex = ~r/current: (?<value>[0-9]+),/
        captures = Regex.named_captures(regex, output)
        {:ok, captures["value"]}
    end
  end

  defp execute_ddcctl_query(property_name) do
    arg = ddcctl_property_argument(property_name)
    args = ["-d", "1", arg, "\?"]

    case @system.cmd("ddcctl", args) do
      {output, 0} -> output
      _ -> :error
    end
  end

  defp ddcctl_property_argument(property_name) do
    property_name_characters = String.codepoints(property_name)
    first_char_of_name = Enum.at(property_name_characters, 0)
    "-#{first_char_of_name}"
  end
end
