use Mix.Config

config :recurring_events, ecto_repos: [RecurringEvents.Repo]

import_config "#{Mix.env}.exs"
