
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

  describe "delete" do
    test "should delete an existing event" do
      %{id: id} = insert(:event)

      assert 1      = count(:events)
      assert {1, _} = Event.Mutator.delete(id)
      assert 0      = count(:events)
    end

    test "should remove all Repetitions" do
      %{id: id} = insert(:event)

      assert 1      = count(:repetitions)
      assert {1, _} = Event.Mutator.delete(id)
      assert 0      = count(:repetitions)
    end

    test "should not delete a nonexistent event" do
      assert {0, nil} = Event.Mutator.delete(Ecto.UUID.generate())
    end
  end

  defp event_from_repo(),
    do: Event |> Repo.one() |> Repo.preload(:repetitions)

  defp count(:events),      do: count(Event)
  defp count(:repetitions), do: count(Event.Repetition)
  defp count(schema),       do: Repo.aggregate(schema, :count, :id)
end
