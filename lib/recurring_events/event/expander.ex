defmodule RecurringEvents.Event.Expander do
  alias RecurringEvents.Event

  @number_of_occurrences 30

  def run(%{id: id, repetitions: repetitions} = event) do
    event
    |> Map.put(:occurrences, expand_repetitions(repetitions, id))
    |> Map.delete(:repetitions)
  end

  defp expand_repetitions(repetitions, event_id) do
    repetitions
    |> Stream.flat_map(&expand_repetition(&1, event_id))
    |> Stream.reject(&past_occurrence/1)
    |> Stream.take(@number_of_occurrences)
    |> Enum.to_list()
  end

  defp expand_repetition(repetition, event_id),
    do: Event.Repetition.Expander.stream(repetition, event_id)

  defp past_occurrence(%Event.Repetition.Occurrence{date: date}),
    do: Ecto.Date.compare(date, Ecto.Date.utc) == :lt
end
