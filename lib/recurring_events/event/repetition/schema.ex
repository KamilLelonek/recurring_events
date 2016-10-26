defmodule RecurringEvents.Event.Repetition do
  use RecurringEvents.Schema

  alias __MODULE__
  alias RecurringEvents.Event

  schema "repetitions" do
    field :frequency,  Repetition.Frequency
    field :interval,   :integer
    field :start_date, Ecto.Date
    field :end_date,   Ecto.Date
    field :start_time, Ecto.Time
    field :end_time,   Ecto.Time
    field :exclusions, {:array, Ecto.Date}, default: []

    belongs_to :event, Event

    timestamps()
  end

  def stream(%Repetition{frequency: frequency, interval: interval, start_date: start_date, end_date: end_date, exclusions: exclusions}),
    do: Repetition.Frequency.stream_of_dates(frequency, interval, start_date, end_date, exclusions)
end
