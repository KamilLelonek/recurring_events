defmodule RecurringEvents.ChangesetTest do
  use ExUnit.Case, async: true

  alias RecurringEvents.Event.Repetition

  @repetition %Repetition{interval: 1}

  defmodule TestChangeset do
    use RecurringEvents.Changeset
  end

  test "should fetch data fields from a Changeset" do
    assert [nil] = fetch_fields_from_repetition([:x])
    assert [1]   = fetch_fields_from_repetition([:interval])
  end

  test "should fetch changed fields from a Changeset" do
    assert [:once] = TestChangeset.fetch_fields(repetition_with_frequency(), [:frequency])
  end

  test "should fetch all fields from a Changeset" do
    assert [:once, 1, nil] = TestChangeset.fetch_fields(repetition_with_frequency(), [:frequency, :interval, :x])
  end

  defp fetch_fields_from_repetition(fields),
    do: @repetition |> Ecto.Changeset.change() |> TestChangeset.fetch_fields(fields)

  defp repetition_with_frequency() do
    @repetition
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_change(:frequency, :once)
  end
end
