defmodule RecurringEvents.Event.Mutator do
  use RecurringEvents.Mutator

  alias RecurringEvents.Event
  alias RecurringEvents.Event.Queries

  def create(params) do
    params
    |> Event.Changeset.build()
    |> Repo.insert()
  end

  def delete(id) do
    id
    |> Queries.by_id()
    |> Repo.delete_all()
  end
end
