defmodule RecurringEvents.Event.MutatorTest do
  use RecurringEvents.TestCase, async: true

  alias RecurringEvents.Event

  @event :event |> params_for() |> Map.put(:repetitions, [params_for(:repetition)])

  describe "create" do
    test "should create a valid Event" do
      {:ok, event} = Event.Mutator.create(@event)

      assert event == event_from_repo()
    end

    test "should not create a valid Event" do
      {:error, %Ecto.Changeset{errors: errors}} = Event.Mutator.create(%{@event | name: nil})

      assert {:name, {"can't be blank", [validation: :required]}} in errors
    end
  end

  describe "update" do
    test "should change an Event name" do
      %{id: id, name: name} = insert(:event)
      new_name              = "New Event name"

      assert name
      refute name == new_name

      {1, [event]} = Event.Mutator.update(id, new_name)

      assert event.name == new_name
    end
  end

  describe "delete" do
    test "should delete an existing Event" do
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

    test "should not delete a nonexistent Event" do
      assert {0, nil} = Event.Mutator.delete(Ecto.UUID.generate())
    end
  end

  defp event_from_repo(),
    do: Event |> Repo.one() |> Repo.preload(:repetitions)

  defp count(:events),      do: count(Event)
  defp count(:repetitions), do: count(Event.Repetition)
  defp count(schema),       do: Repo.aggregate(schema, :count, :id)
end
