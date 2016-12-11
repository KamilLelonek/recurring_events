defmodule RecurringEvents.Test.Factory do
  use ExMachina.Ecto, repo: RecurringEvents.Repo

  alias RecurringEvents.Event
  alias RecurringEvents.Event.Repetition

  def repetition_factory() do
    %Repetition{
      frequency:  :daily,
      interval:   2,
      start_date: %Ecto.Date{day: 1, month: 1, year: 2000},
      end_date:   %Ecto.Date{day: 1, month: 2, year: 2000},
      start_time: %Ecto.Time{hour: 1, min: 0, sec: 0},
      end_time:   %Ecto.Time{hour: 2, min: 0, sec: 0}
    }
  end

  def event_factory() do
    %Event{
      name:        sequence("Event Name"),
      repetitions: build_list(1, :repetition)
    }
  end
end
