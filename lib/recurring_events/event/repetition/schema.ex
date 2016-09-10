defmodule RecurringEvents.Event.Repetition do
  use RecurringEvents.Schema

  alias __MODULE__
  alias RecurringEvents.Event

  schema "repetitions" do
    field :frequency,  Repetition.Frequency
    field :interval,   :integer
    field :starts_at,  Ecto.DateTime
    field :ends_at,    Ecto.DateTime
    field :exclusions, {:array, Ecto.Date}, default: []

    belongs_to :event, Event

    timestamps()
  end

  def stream(%Repetition{frequency: frequency, interval: interval, starts_at: starts_at, ends_at: ends_at, exclusions: exclusions}),
    do: Repetition.Frequency.stream_of_dates(frequency, interval, starts_at, ends_at, exclusions)
end
