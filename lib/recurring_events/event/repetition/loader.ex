defmodule RecurringEvents.Event.Repetition.Loader do
  use RecurringEvents.Loader
  
  alias RecurringEvents.Event.Repetition

  def by_id!(id),
    do: Repo.get!(Repetition, id)
end
