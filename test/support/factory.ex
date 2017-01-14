defmodule RecurringEvents.Test.Factory do
  use ExMachina.Ecto, repo: RecurringEvents.Repo

  alias RecurringEvents.Event
  alias RecurringEvents.Event.Repetition

  def repetition_factory() do
    %Repetition{
      id:         Ecto.UUID.generate(),
      frequency:  :yearly,
      interval:   1,
      start_date: %Ecto.Date{year: 2000, month: 1, day: 1},
      end_date:   %Ecto.Date{year: 2002, month: 1, day: 1},
      start_time: %Ecto.Time{hour: 0, min: 0, sec: 0},
      end_time:   %Ecto.Time{hour: 1, min: 0, sec: 0},
      exclusions: [%Ecto.Date{year: 2001, month: 1, day: 1}]
    }
  end

  def event_factory() do
    %Event{
      name:        sequence("Event Name"),
      repetitions: build_list(1, :repetition)
    }
  end
end
