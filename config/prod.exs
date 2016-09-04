use Mix.Config

config :recurring_events, RecurringEvents.Repo,
  adapter:   Ecto.Adapters.Postgres,
  url:       {:system, "DATABASE_URL"},
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
