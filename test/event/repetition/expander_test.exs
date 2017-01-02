defmodule RecurringEvents.Event.Repetition.ExpanderTest do
  use RecurringEvents.TestCase, async: true

  alias RecurringEvents.Event.Repetition

  test "should generate stream of dates" do
    repetition = %Repetition{
      id:         Ecto.UUID.generate(),
      frequency:  :yearly,
      interval:   1,
      start_date: %Ecto.Date{year: 2000, month: 1, day: 1},
      end_date:   %Ecto.Date{year: 2002, month: 1, day: 1},
      start_time: %Ecto.Time{hour: 0, min: 0, sec: 0},
      end_time:   %Ecto.Time{hour: 1, min: 0, sec: 0},
      exclusions: [%Ecto.Date{year: 2001, month: 1, day: 1}]
    }

    assert [
      %Repetition.Occurence{
        repetition_id: repetition.id,
        date:          %Ecto.Date{year: 2000, month: 1, day: 1},
        time_start:    %Ecto.Time{hour: 0, min: 0, sec: 0},
        time_end:      %Ecto.Time{hour: 1, min: 0, sec: 0}
      },
      %Repetition.Occurence{
        repetition_id: repetition.id,
        date:          %Ecto.Date{year: 2002, month: 1, day: 1},
        time_start:    %Ecto.Time{hour: 0, min: 0, sec: 0},
        time_end:      %Ecto.Time{hour: 1, min: 0, sec: 0}
      },
    ] == repetition |> Repetition.Expander.stream() |> Enum.to_list()
  end
end
