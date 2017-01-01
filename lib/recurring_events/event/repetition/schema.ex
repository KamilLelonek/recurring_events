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
end
