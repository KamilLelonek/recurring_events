defmodule RecurringEvents.Event.Repetition.FrequencyTest do
  use RecurringEvents.TestCase, async: true

  alias RecurringEvents.Event.Repetition.Frequency

  describe "add_days" do
    test "should add a couple of days and change a month",
      do: assert %Ecto.Date{year: 2015, month: 3, day: 2} == Frequency.add_days(%Ecto.Date{year: 2015, month: 2, day: 27}, 3)

    test "should add a couple of days and change a year",
      do: assert %Ecto.Date{year: 2016, month: 1, day: 1} == Frequency.add_days(%Ecto.Date{year: 2015, month: 12, day: 30}, 2)

    test "should subtract a couple of days within a month",
      do: assert %Ecto.Date{year: 2015, month: 2, day: 24} == Frequency.add_days(%Ecto.Date{year: 2015, month: 2, day: 27}, -3)
  end

  describe "add_months" do
    @last_jan_2015 %Ecto.Date{year: 2015, month: 1, day: 31}

    test "should add a month and change to a shorter one" do
      assert %Ecto.Date{year: 2015, month: 2, day: 28} == Frequency.add_months(@last_jan_2015, 1)
    end

    test "should add months and change to the next year" do
      assert %Ecto.Date{year: 2016, month: 1, day: 31} == Frequency.add_months(@last_jan_2015, 12)
    end

    test "should pick the correct last day of the month the next year" do
      assert %Ecto.Date{year: 2016, month: 2, day: 29} == Frequency.add_months(@last_jan_2015, 13)
    end
  end

  describe "stream_of_dates" do
    test "should generate only one date for :once frequency" do
      frequency  = :once
      interval   = nil
      date_start = %Ecto.Date{year: 2000, month: 1, day: 1}
      date_end   = %Ecto.Date{year: 3000, month: 1, day: 1}

      assert_stream_of_dates(frequency, interval, date_start, date_end, [date_start], [])
      assert_stream_of_dates(frequency, interval, date_start, date_end, [date_start], [%Ecto.Date{year: 2000, month: 1, day: 1}])
      assert_stream_of_dates(frequency, interval, date_start, date_end, [date_start], [%Ecto.Date{year: 3000, month: 1, day: 1}])
      assert_stream_of_dates(frequency, interval, date_start, date_end, [date_start], [%Ecto.Date{year: 2000, month: 1, day: 1}, %Ecto.Date{year: 3000, month: 1, day: 1}])
    end

    test "should generate a stream of dates for every day" do
      frequency      = :daily
      interval       = 1
      date_start     = %Ecto.Date{year: 2000, month: 1, day: 1}
      date_end       = %Ecto.Date{year: 2000, month: 1, day: 3}
      excluded_dates = [
        %Ecto.Date{year: 2000, month: 1, day: 1},
        %Ecto.Date{year: 2000, month: 1, day: 2},
        %Ecto.Date{year: 2000, month: 1, day: 3},
      ]

      assert_stream_of_dates(frequency, interval, date_start, date_end, [], excluded_dates)
    end

    test "should generate a stream of dates for every second week" do
      frequency  = :weekly
      interval   = 2
      date_start = %Ecto.Date{year: 2000, month: 1, day:  1}
      date_end   = %Ecto.Date{year: 2000, month: 1, day: 31}
      dates      = [
        %Ecto.Date{year: 2000, month: 1, day: 15},
        %Ecto.Date{year: 2000, month: 1, day: 29},
      ]

      assert_stream_of_dates(frequency, interval, date_start, date_end, dates, [%Ecto.Date{year: 2000, month: 1, day:  1}])
    end

    test "should generate a stream of dates for every third month" do
      frequency  = :monthly
      interval   = 3
      date_start = %Ecto.Date{year: 2000, month:  1, day:  1}
      date_end   = %Ecto.Date{year: 2000, month: 12, day: 31}
      dates      = [
        %Ecto.Date{year: 2000, month:  1, day: 1},
        %Ecto.Date{year: 2000, month:  4, day: 1},
        %Ecto.Date{year: 2000, month:  7, day: 1},
      ]

      assert_stream_of_dates(frequency, interval, date_start, date_end, dates, [%Ecto.Date{year: 2000, month: 10, day: 1}])
    end

    test "should generate a stream of dates for every fourth year" do
      frequency  = :yearly
      interval   = 4
      date_start = %Ecto.Date{year: 2000, month: 1, day: 1}
      date_end   = %Ecto.Date{year: 2020, month: 1, day: 1}
      dates      = [
        %Ecto.Date{year: 2000, month: 1, day: 1},
        %Ecto.Date{year: 2004, month: 1, day: 1},
        %Ecto.Date{year: 2008, month: 1, day: 1},
        %Ecto.Date{year: 2016, month: 1, day: 1},
        %Ecto.Date{year: 2020, month: 1, day: 1},
      ]

      assert_stream_of_dates(frequency, interval, date_start, date_end, dates, [%Ecto.Date{year: 2012, month: 1, day: 1}])
    end

    defp assert_stream_of_dates(frequency, interval, date_start, date_end, dates, exclusions),
      do: assert dates == frequency |> Frequency.stream_of_dates(interval, date_start, date_end, exclusions) |> Enum.to_list
  end
end
