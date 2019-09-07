defmodule MonitorTest do
  use ExUnit.Case
  alias Brite.Monitor, as: Monitor

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

  describe "query(:brightness)" do
    test "returns current brightness" do
      assert @default_brightness == Monitor.query(:brightness)
    end
  end

  describe "query(:contrast)" do
    test "returns the current contrast" do
      assert @default_contrast == Monitor.query(:contrast)
    end
  end

  describe "adjust(:brighten)" do
    test "increases brightness & contrast by 5" do
      Monitor.adjust(:brighten)

      adjusted_brightness = @default_brightness + 5
      adjusted_contrast = @default_contrast + 5

      assert adjusted_brightness == Monitor.query(:brightness)
      assert adjusted_contrast == Monitor.query(:contrast)
    end
  end

  describe "adjust(:darken)" do
    test "decreases brightness & contrast by 5" do
      Monitor.adjust(:darken)

      adjusted_brightness = @default_brightness - 5
      adjusted_contrast = @default_contrast - 5

      assert adjusted_brightness == Monitor.query(:brightness)
      assert adjusted_contrast == Monitor.query(:contrast)
    end
  end
end
