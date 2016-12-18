defmodule RecurringEvents.Event.Mutator do
  use RecurringEvents.Mutator

  alias RecurringEvents.Event

  def create(params) do
    params
    |> Event.Changeset.build()
    |> Repo.insert()
  end

  def delete(id) do
    id
    |> event_by_id_query()
    |> Repo.delete_all()
  end

  defp event_by_id_query(id),
    do: from e in Event, where: e.id == ^id
end
