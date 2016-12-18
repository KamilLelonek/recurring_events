
defmodule RecurringEvents.Event.MutatorTest do
  use RecurringEvents.TestCase, async: true

  alias RecurringEvents.Event

  @event :event |> params_for() |> Map.put(:repetitions, [params_for(:repetition)])

  describe "create" do
    test "should create a valid event" do
      {:ok, event} = Event.Mutator.create(@event)

      assert event == event_from_repo()
    end

    test "should not create a valid event" do
      {:error, %Ecto.Changeset{errors: errors}} = Event.Mutator.create(%{@event | name: nil})

      assert {:name, {"can't be blank", [validation: :required]}} in errors
    end
  end

  defp event_from_repo(),
    do: Event |> Repo.one() |> Repo.preload(:repetitions)
end
