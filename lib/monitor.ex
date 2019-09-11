defmodule Brite.Monitor do
  alias Brite.Ddcctl, as: Ddcctl

  def brighten(value \\ 5) do
    new_brightness = Ddcctl.query("brightness") + value
    Ddcctl.set("brightness", new_brightness)

    new_contrast = Ddcctl.query("contrast") + value
    Ddcctl.set("contrast", new_contrast)
  end

  def darken(value \\ 5) do
    new_brightness = Ddcctl.query("brightness") - value
    Ddcctl.set("brightness", new_brightness)

    new_contrast = Ddcctl.query("contrast") - value
    Ddcctl.set("contrast", new_contrast)
  end

  def query(:brightness), do: Ddcctl.query("brightness")
  def query(:contrast), do: Ddcctl.query("contrast")

  def set(brightness, contrast) do
    Ddcctl.set("brightness", brightness)
    Ddcctl.set("contrast", contrast)
  end
end
