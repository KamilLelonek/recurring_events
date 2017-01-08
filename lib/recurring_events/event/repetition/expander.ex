defmodule RecurringEvents.Event.Repetition.Expander do
  alias RecurringEvents.Event.Repetition

  def stream(%{frequency: frequency, interval: interval, start_date: start_date, end_date: end_date, exclusions: exclusions} = repetition, event_id \\ nil) do
    frequency
    |> Repetition.Frequency.stream_of_dates(interval, start_date, end_date, exclusions)
    |> Enum.map(&build_occurence(&1, repetition, event_id))
  end

  defp build_occurence(date, repetition, event_id) do
    %Repetition.Occurence{
      event_id:      event_id,
      date:          date,
      time_start:    repetition.start_time,
      time_end:      repetition.end_time,
      repetition_id: repetition.id,
    }
  end
end

