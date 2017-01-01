defmodule RecurringEvents.Event.Repetition.Expander do
  alias RecurringEvents.Event.Repetition

  def stream(%Repetition{frequency: frequency, interval: interval, start_date: start_date, end_date: end_date, exclusions: exclusions}),
    do: Repetition.Frequency.stream_of_dates(frequency, interval, start_date, end_date, exclusions)
end

