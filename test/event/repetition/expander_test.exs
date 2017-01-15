defmodule RecurringEvents.Event.Repetition.ExpanderTest do
  use RecurringEvents.TestCase, async: true

  alias RecurringEvents.Event.Repetition

  @event_id Ecto.UUID.generate()

  test "should generate stream of dates" do
    repetition = insert(:repetition)

    assert [
      %Repetition.Occurence{
        event_id:      @event_id,
        repetition_id: repetition.id,
        date:          %Ecto.Date{year: 2020, month: 1, day: 1},
        time_start:    %Ecto.Time{hour: 0, min: 0, sec: 0},
        time_end:      %Ecto.Time{hour: 1, min: 0, sec: 0}
      },
      %Repetition.Occurence{
        event_id:      @event_id,
        repetition_id: repetition.id,
        date:          %Ecto.Date{year: 2022, month: 1, day: 1},
        time_start:    %Ecto.Time{hour: 0, min: 0, sec: 0},
        time_end:      %Ecto.Time{hour: 1, min: 0, sec: 0}
      },
    ] == repetition |> Repetition.Expander.stream(@event_id) |> Enum.to_list()
  end
end
