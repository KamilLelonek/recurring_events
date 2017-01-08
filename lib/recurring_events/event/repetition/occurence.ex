defmodule RecurringEvents.Event.Repetition.Occurence do
  @keys ~w(date time_start time_end repetition_id event_id)a

  @enforce_keys @keys

  defstruct @keys
end
