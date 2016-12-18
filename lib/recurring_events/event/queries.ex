defmodule RecurringEvents.Event.Queries do
  use RecurringEvents.Queries

  alias RecurringEvents.Event

  def by_id(id),
    do: from e in Event, where: e.id == ^id
end
