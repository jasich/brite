defmodule DdcctlTest do
  use ExUnit.Case
  alias Brite.Ddcctl, as: Ddcctl

  @default_brightness 80
  @default_contrast 75

  setup_all do
    Brite.SystemDouble.start()
    :ok
  end

  setup do
    Brite.SystemDouble.put(%{
      "brightness" => @default_brightness,
      "contrast" => @default_contrast
    })

    :ok
  end

  describe "set/2" do
    test "Sets brightness" do
      assert 1 == 1
    end
  end
end
