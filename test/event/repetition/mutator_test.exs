defmodule RecurringEvents.Event.Repetition.MutatorTest do
  use RecurringEvents.TestCase, async: true

  alias RecurringEvents.Event.Repetition

  @date_to_exclude "2000-01-01"

  setup do
    %{id: id} = insert(:repetition)

    {:ok, id: id}
  end

  describe "exclude" do
    test "should exclude a valid date", %{id: id} do
      {:ok, %{exclusions: [excluded_date]}} = Repetition.Mutator.exclude(id, @date_to_exclude)

      assert excluded_date == Ecto.Date.cast!(@date_to_exclude)
    end

    test "should not exclude any date for frequency :once" do
      %{id: id} = insert(:repetition, frequency: :once)

      refute_excluded(id, @date_to_exclude, "Must be other than :once. Only a recurring Repetition can be excluded.", :frequency)
    end

    test "should not exclude an already excluded date", %{id: id} do
      {:ok, %{exclusions: [excluded_date]}} = Repetition.Mutator.exclude(id, @date_to_exclude)

      refute_excluded(id, excluded_date, "The given date #{excluded_date} is already excluded.")
    end

    test "should not exclude a nonexistent occurence", %{id: id} do
      date_to_exclude = "2000-01-02"

      refute_excluded(id, date_to_exclude, "The Event does not oocur at #{date_to_exclude}.")
    end

    test "should not exclude an invalid date", %{id: id} do
      refute_excluded(id, "13-13-1313", "Must be a valid date in format YYYY-MM-DD.")
    end

    defp refute_excluded(id, date_to_exclude, message, error \\ :date) do
      {:error, %{errors: errors}} = Repetition.Mutator.exclude(id, date_to_exclude)

      assert {error, {message, []}} in errors
    end
  end
end
