defmodule RecurringEvents.Event.SchemaTest do
  use RecurringEvents.TestCase, async: true

  alias RecurringEvents.Event

  @event :event |> params_for() |> Map.put(:repetitions, [params_for(:repetition)])

  test "should pass for a valid event" do
    assert %{} == errors_on_create(@event)
  end

  describe "name" do
    test "should fail for missing name" do
      assert {:name, [{"can't be blank", []}]} in errors_on_create(name: nil)
    end

    test "should fail for an empty name" do
      assert {:name, [{"can't be blank", []}]} in errors_on_create(name: "")
    end
  end

  describe "repetition" do
    test "should fail for missing repetition" do
      assert {:repetitions, [{"is invalid", [type: {:array, :map}]}]} in errors_on_create(repetitions: nil)
    end

    test "should fail for an empty repetition" do
      assert {:repetitions, [{"can't be blank", []}]} in errors_on_create(repetitions: [])
    end

    test "should fail for an invalid repetition" do
      assert %{repetitions: _} = errors_on_create(repetitions: [%{}])
    end
  end

  defp errors_on_create(params),
    do: errors_on_create(params, @event, Event.Changeset)
end
