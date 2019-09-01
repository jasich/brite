defmodule Brite.SystemDouble do
  def start(initial \\ %{}) do
    process = spawn_link(fn -> execute(initial) end)
    Process.register(process, Brite.SystemDouble)
    process
  end

  def execute(state) do
    receive do
      {:get, sender} ->
        send(sender, state)
        execute(state)

      {:put, val} ->
        execute(val)
    end
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

  def cmd(_command, args) do
    cond do
      brightness_query?(args) ->
        {"current: #{current_brightness()},", 0}

      contrast_query?(args) ->
        {"current: #{current_contrast()},", 0}

      adjustment?(args) ->
        third_to_last_index = length(args) - 3
        contrast = Enum.at(args, third_to_last_index)

        put(%{
          "brightness" => Enum.at(args, length(args) - 1),
          "contrast" => contrast
        })

        {"blah", 0}

      true ->
        {"", 1}
    end
  end

  def current_brightness do
    send(Brite.SystemDouble, {:get, self()})

    receive do
      msg -> msg["brightness"]
    end
  end

  def current_contrast do
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

  defp adjustment?(args) do
    second_to_last_index = length(args) - 2
    query_item = Enum.at(args, second_to_last_index)
    List.last(args) != "?" && query_item == "-b"
  end
end
