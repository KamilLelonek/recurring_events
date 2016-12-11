defmodule RecurringEvents.Event.Mutator do
  alias RecurringEvents.Event

  alias RecurringEvents.Repo

  def create(params) do
    params
    |> Event.Changeset.build()
    |> Repo.insert()
  end
end
