defmodule RecurringEvents.Event.Repetition.ChangesetTest do
  use RecurringEvents.TestCase, async: true

  alias RecurringEvents.Event.Repetition

  @repetition params_for(:repetition)

  test "should pass for a valid rapetition" do
    assert %{} == errors_on_create(@repetition)
  end

  describe "frequency" do
    test "should fail for invalid frequency values" do
      assert {:frequency, [{"is invalid", [type: Repetition.Frequency, validation: :cast]}]} in errors_on_create(frequency: :randomly)
      assert {:frequency, [{"must occur only :once for :interval 0", []}]} in errors_on_create(interval: 0)
    end
  end

  describe "interval" do
    test "should fail for an invalid frequency and interval" do
      assert {:interval, [{"must be greater than or equal to %{number}", [validation: :number, number: 0]}]} in errors_on_create(interval: -1)
      assert {:interval, [{"must be 0 for frequency :once", []}]} in errors_on_create(frequency: :once)
    end
  end

  describe "start_date" do
    test "should fail when end_date is before start_date" do
      assert {:start_date, [{"must be less or equal to :end_date", []}]} in errors_on_create(end_date: %{@repetition.end_date | year: 1000})
    end
  end

  describe "start_time" do
    test "should fail when start_time is before end_time for the same dates" do
      errors = errors_on_create(
        end_date: @repetition.start_date,
        end_time: @repetition.start_time
      )

      assert {:start_time, [{"must be less than :end_time for the same dates", []}]} in errors
    end
  end

  defp errors_on_create(params),
    do: errors_on_create(params, @repetition, Repetition.Changeset)
end
