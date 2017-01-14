
defmodule RecurringEvents.Event.ExpanderTest do
  use RecurringEvents.TestCase, async: true

  alias RecurringEvents.Event

  test "should expand all Events" do
    %{repetitions: [%{id: repetition_id}]} = event = insert(:event)

    %{repetitions: repetitions} = Event.Expander.stream(event)

    assert [
      %Event.Repetition.Occurence{
        event_id:      event.id,
        repetition_id: repetition_id,
        date:          %Ecto.Date{year: 2000, month: 01, day: 01},
        time_start:    %Ecto.Time{hour: 0, min: 0, sec: 0},
        time_end:      %Ecto.Time{hour: 1, min: 0, sec: 0},
      },
      %Event.Repetition.Occurence{
        event_id:      event.id,
        repetition_id: repetition_id,
        date:          %Ecto.Date{year: 2002, month: 01, day: 01},
        time_start:    %Ecto.Time{hour: 0, min: 0, sec: 0},
        time_end:      %Ecto.Time{hour: 1, min: 0, sec: 0},
      },
    ] == repetitions |> Enum.to_list()
  end
end
