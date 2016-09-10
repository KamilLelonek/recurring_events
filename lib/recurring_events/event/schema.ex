defmodule RecurringEvents.Event do
  use RecurringEvents.Schema

  alias RecurringEvents.Event.Repetition

  schema "events" do
    field :name, :string

    has_many :repetitions, Repetition, on_delete: :delete_all

    timestamps()
  end
end
