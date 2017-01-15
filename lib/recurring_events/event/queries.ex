defmodule RecurringEvents.Event.Queries do
  use RecurringEvents.Queries

  alias RecurringEvents.Event

  def by_id(id),
    do: from Event, where: [id: ^id]

  def by_id_with_associations(id),
    do: from by_id(id), preload: [:repetitions]

  def all_with_associations(),
    do: from Event, preload: [:repetitions]
end
