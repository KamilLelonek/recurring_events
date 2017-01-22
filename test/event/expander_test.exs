
defmodule RecurringEvents.Event.ExpanderTest do
  use RecurringEvents.TestCase, async: true

  alias RecurringEvents.Event

  test "should expand all Events" do
    %{repetitions: [%{id: repetition_id}]} = event = build(:event)

    %{occurrences: repetitions} = Event.Expander.run(event)

    assert [
      %Event.Repetition.Occurrence{
        event_id:      event.id,
        repetition_id: repetition_id,
        date:          %Ecto.Date{year: 2020, month: 01, day: 01},
        time_start:    %Ecto.Time{hour: 0, min: 0, sec: 0},
        time_end:      %Ecto.Time{hour: 1, min: 0, sec: 0},
      },
      %Event.Repetition.Occurrence{
        event_id:      event.id,
        repetition_id: repetition_id,
        date:          %Ecto.Date{year: 2022, month: 01, day: 01},
        time_start:    %Ecto.Time{hour: 0, min: 0, sec: 0},
        time_end:      %Ecto.Time{hour: 1, min: 0, sec: 0},
      },
    ] == repetitions
  end

  test "should reject past Occurrences" do
    repetition = build(:repetition, %{start_date: %Ecto.Date{year: 2000, month: 1, day: 1}})
    event      = build(:event, repetitions: [repetition])

    %{occurrences: [%{date: first_repetition_date} | _]} = Event.Expander.run(event)

    refute Ecto.Date.compare(first_repetition_date, Ecto.Date.utc) == :lt
  end

  test "should limit Occurrences in the future" do
    repetition = build(:repetition, %{end_date: %Ecto.Date{year: 3000, month: 1, day: 1}})
    event      = build(:event, repetitions: [repetition])

    %{occurrences: repetitions} = Event.Expander.run(event)

    assert 30 = Enum.count(repetitions)
  end
end
