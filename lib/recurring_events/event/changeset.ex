defmodule RecurringEvents.Event.Changeset do
  use RecurringEvents.Changeset

  alias RecurringEvents.Event
  alias RecurringEvents.Event.Repetition

  @assocs_required %{
    repetition: true,
  }

  @params_required ~w(name)a
  @params_optional ~w()a

  def build(schema \\ %Event{}, params) do
    schema
    |> cast(params, @params_required ++ @params_optional)
    |> validate_required(@params_required)
    |> cast_repetition()
  end

  defp cast_repetition(changeset),
    do: cast_assoc(changeset, :repetitions, with: &Repetition.Changeset.build/2, required: @assocs_required[:repetition])
end
