defmodule Brite.SystemDouble do
  @behaviour Brite.Systemable

  def start(initial \\ %{}) do
    process = spawn_link(fn -> execute(initial) end)
    Process.register(process, Brite.SystemDouble)
    process
  end

  def put(value) do
    send(Brite.SystemDouble, {:put, value})
  end

  def get do
    send(Brite.SystemDouble, {:get, self()})

    receive do
      msg -> msg["brightness"]
    end
  end

  @impl Brite.Systemable
  def cmd(_command, args) do
    cond do
      brightness_query?(args) ->
        {"current: #{current_brightness()},", 0}

      contrast_query?(args) ->
        {"current: #{current_contrast()},", 0}

      brightness_adjustment?(args) ->
        send(Brite.SystemDouble, {:get, self()})

        receive do
          ddcctl_values ->
            new_value = Map.put(ddcctl_values, "brightness", Enum.at(args, length(args) - 1))
            put(new_value)

            {"blah", 0}
        end

      contrast_adjustment?(args) ->
        send(Brite.SystemDouble, {:get, self()})

        receive do
          ddcctl_values ->
            new_value = Map.put(ddcctl_values, "contrast", Enum.at(args, length(args) - 1))
            put(new_value)

            {"blah", 0}
        end

      true ->
        {"", 1}
    end
  end

  defp execute(state) do
    receive do
      {:get, sender} ->
        send(sender, state)
        execute(state)

      {:put, val} ->
        execute(val)
    end
  end

  defp current_brightness do
    send(Brite.SystemDouble, {:get, self()})

    receive do
      msg -> msg["brightness"]
    end
  end

  defp current_contrast do
    send(Brite.SystemDouble, {:get, self()})

    receive do
      msg -> msg["contrast"]
    end
  end

  defp brightness_query?(args) do
    second_to_last_index = length(args) - 2
    query_item = Enum.at(args, second_to_last_index)
    List.last(args) == "?" && query_item == "-b"
  end

  defp contrast_query?(args) do
    second_to_last_index = length(args) - 2
    query_item = Enum.at(args, second_to_last_index)
    List.last(args) == "?" && query_item == "-c"
  end

  defp brightness_adjustment?(args) do
    second_to_last_index = length(args) - 2
    query_item = Enum.at(args, second_to_last_index)
    List.last(args) != "?" && query_item == "-b"
  end

  defp contrast_adjustment?(args) do
    second_to_last_index = length(args) - 2
    query_item = Enum.at(args, second_to_last_index)
    List.last(args) != "?" && query_item == "-c"
  end
end
