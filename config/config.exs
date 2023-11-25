# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :core, :ecto_repos, [
  GoEscuelaLms.Core.Repo
]

config :core, GoEscuelaLms.Core.Repo,
  url: System.get_env("DATABASE_URL"),
  show_sensitive_data_on_connection_error: true,
  pool_size: 2
