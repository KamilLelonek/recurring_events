defmodule RecurringEvents.Event.Expander do
  alias RecurringEvents.Event

  @number_of_occurences 30

  def run(%{id: id, repetitions: repetitions} = event),
    do: %Event{event | repetitions: expand_repetitions(repetitions, id)}

  defp expand_repetitions(repetitions, event_id) do
    repetitions
    |> Stream.flat_map(&expand_repetition(&1, event_id))
    |> Stream.reject(&past_occurence/1)
    |> Stream.take(@number_of_occurences)
    |> Enum.to_list()
  end

  defp expand_repetition(repetition, event_id),
    do: Event.Repetition.Expander.stream(repetition, event_id)

  defp past_occurence(%Event.Repetition.Occurence{date: date}),
    do: Ecto.Date.compare(date, Ecto.Date.utc) == :lt
end
