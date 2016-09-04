use Mix.Config

config :recurring_events, RecurringEvents.Repo,
  adapter:   Ecto.Adapters.Postgres,
  hostname:  "localhost",
  username:  "postgres",
  password:  "postgres",
  database:  "recurring_events_test",
  pool:      Ecto.Adapters.SQL.Sandbox
