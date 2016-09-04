defmodule RecurringEvents do
  use Application

  import Supervisor.Spec, warn: false

  def start(_type, _args), do: Supervisor.start_link(children(), opts())

  defp opts() do
    [
      strategy: :one_for_one,
      name:     RecurringEvents.Supervisor,
    ]
  end

  defp children() do
    [
      supervisor(RecurringEvents.Repo, []),
    ]
  end
end
