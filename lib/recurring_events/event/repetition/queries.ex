defmodule RecurringEvents.Event.Repetition.Queries do
  import Ecto.Query

  alias RecurringEvents.Event.Repetition

  def by_id(id),
    do: from r in Repetition, where: r.id == ^id
end
