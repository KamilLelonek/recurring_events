defmodule RecurringEvents.Event.Mutator do
  use RecurringEvents.Mutator

  alias RecurringEvents.Event

  def create(params) do
    params
    |> Event.Changeset.build()
    |> Repo.insert()
  end

  def update(id, name) do
    id
    |> Event.Queries.by_id()
    |> Repo.update_all(update_fields(name), update_opts())
  end

  def delete(id) do
    id
    |> Event.Queries.by_id()
    |> Repo.delete_all()
  end

  defp update_fields(name),
    do: [set: [name: name]]

  defp update_opts,
    do: [returning: ~w(id name)a]
end
