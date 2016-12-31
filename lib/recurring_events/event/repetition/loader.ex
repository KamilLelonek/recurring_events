defmodule RecurringEvents.Event.Repetition.Loader do
  alias RecurringEvents.{Repo, Event.Repetition}

  def by_id!(id),
    do: Repo.get!(Repetition, id)
end
