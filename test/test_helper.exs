ExUnit.start(capture_log: true)

Ecto.Adapters.SQL.Sandbox.mode(RecurringEvents.Repo, :manual)

{:ok, _} = Application.ensure_all_started(:ex_machina)
