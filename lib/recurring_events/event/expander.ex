defmodule RecurringEvents.Event.Expander do
  alias RecurringEvents.Event

  def stream(%{id: id, name: name, repetitions: repetitions}) do
    %Event{
      name:        name,
      repetitions: expand_repetitions(repetitions, id),
    }
  end

  defp expand_repetitions(repetitions, event_id),
    do: Stream.flat_map(repetitions, &expand_repetition(&1, event_id))

  defp expand_repetition(repetition, event_id),
    do: Event.Repetition.Expander.stream(repetition, event_id)
end

