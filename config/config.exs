use Mix.Config

config :brite, :system, Brite.NativeSystem

import_config "#{Mix.env()}.exs"
