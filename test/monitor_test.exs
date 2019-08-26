defmodule MonitrorTest do
  use ExUnit.Case, async: true

  describe "adjust with :brighten" do
    test "increases brightness & contrast by 5" do
      assert 85 == Brite.Monitor.adjust(:brighten)
    end
  end
end
