defmodule RecurringEvents.Event.LoaderTest do
  use RecurringEvents.TestCase, async: true

  alias RecurringEvents.Event

  describe "Multiple Events" do
    test "should load collapsed Events" do
      insert(:event)

      [%{repetitions: [_]}] = Event.Loader.all(:collapsed)
    end

    test "should load expanded Events" do
      insert(:event)

      [%{occurrences: [_, _]}] = Event.Loader.all(:expanded)
    end

    test "should not load any Events" do
      assert [] == Event.Loader.all(:collapsed)
      assert [] == Event.Loader.all(:expanded)
    end
  end

  describe "A single Event" do
    test "should load a collapsed Event" do
      %{id: id} = insert(:event)

      %{repetitions: [_]} = Event.Loader.one!(:collapsed, id)
    end

    test "should load an expanded Event" do
      %{id: id} = insert(:event)

      %{occurrences: [_, _]} = Event.Loader.one!(:expanded, id)
    end

    test "should not load any Event" do
      assert_raise Ecto.NoResultsError, fn ->
        Event.Loader.one!(:collapsed, Ecto.UUID.generate())
      end
    end
  end
end
