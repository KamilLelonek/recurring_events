defmodule RecurringEvents.Event.Repetition.SchemaTest do
  use RecurringEvents.TestCase, async: true

  alias RecurringEvents.Event.Repetition

  test "should generate stream of dates" do
    repetition = %Repetition{
      frequency:  :yearly,
      interval:   1,
      start_date:  %Ecto.Date{year: 2000, month: 1, day: 1},
      end_date:    %Ecto.Date{year: 2003, month: 1, day: 1},
      start_time:  %Ecto.Time{hour: 0, min: 0, sec: 0},
      end_time:    %Ecto.Time{hour: 0, min: 0, sec: 0},
      exclusions: [%Ecto.Date{year: 2001, month: 1, day: 1}]
    }

    assert [
      %Ecto.Date{year: 2000, month: 1, day: 1},
      %Ecto.Date{year: 2002, month: 1, day: 1},
      %Ecto.Date{year: 2003, month: 1, day: 1},
      ] == repetition |> Repetition.stream() |> Enum.to_list()
  end
end
