defmodule Brite.Monitor do
  alias Brite.Ddcctl, as: Ddcctl

  @adjust_step 5

  def adjust(:brighten) do
    new_brightness = Ddcctl.query("brightness") + @adjust_step
    Ddcctl.set("brightness", new_brightness)

    new_contrast = Ddcctl.query("contrast") + @adjust_step
    Ddcctl.set("contrast", new_contrast)
  end

  def adjust(:lighten) do
    new_brightness = Ddcctl.query("brightness") - @adjust_step
    Ddcctl.set("brightness", new_brightness)

    new_contrast = Ddcctl.query("contrast") - @adjust_step
    Ddcctl.set("contrast", new_contrast)
  end

  def query(:brightness), do: Ddcctl.query("brightness")
  def query(:contrast), do: Ddcctl.query("contrast")
end
