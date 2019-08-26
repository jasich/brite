use Mix.Config

config :brite, :system, System

import_config "#{Mix.env()}.exs"
