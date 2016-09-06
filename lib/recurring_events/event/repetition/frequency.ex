defmodule RecurringEvents.Event.Repetition.Frequency do
  use Exnumerator,
    values: [
      :once,
      :daily,
      :weekly,
      :monthly,
      :yearly
    ]

  def stream_of_dates(frequency,  interval, date_start,  date_end,  exclusions \\ [])
  def stream_of_dates(:once,     _interval, date_start, _date_end, _exclusions), do: [date_start]
  def stream_of_dates(frequency,  interval, date_start,  date_end,  exclusions)  do
    date_start
    |> generate_dates(frequency, interval)
    |> pick_dates_within_range(date_end)
    |> exclude_dates_out_of_range(exclusions)
  end

  defp generate_dates(date_start, frequency, interval),
    do: Stream.iterate(date_start, &stepper(frequency, interval, &1))

  defp pick_dates_within_range(dates_stream, date_end),
    do: Stream.take_while(dates_stream, &not_future_date?(&1, date_end))

  defp not_future_date?(date, boundary),
    do: Ecto.Date.compare(date, boundary) != :gt

  defp exclude_dates_out_of_range(dates, exclusions),
    do: Stream.reject(dates, &Enum.member?(exclusions, &1))

  defp stepper(:daily,   interval, date), do: add_days(date,   interval)
  defp stepper(:weekly,  interval, date), do: add_days(date,   interval * 7)
  defp stepper(:monthly, interval, date), do: add_months(date, interval)
  defp stepper(:yearly,  interval, date), do: add_months(date, interval * 12)

  def add_days(date, days) do
    date
    |> Ecto.Date.to_erl()
    |> :calendar.date_to_gregorian_days()
    |> Kernel.+(days)
    |> :calendar.gregorian_days_to_date()
    |> Ecto.Date.from_erl()
  end

  def add_months(date, months) do
    date
    |> calculate_year_and_month(months)
    |> adjust_year_and_month()
    |> adjust_day()
  end

  defp calculate_year_and_month(%Ecto.Date{year: year, month: month, day: day}, months),
    do: %Ecto.Date{year: calculate_year(year, months), month: calculate_month(month, months), day: day}

  defp calculate_year(year, months),
    do: year + div(months, 12)

  defp calculate_month(month, months),
    do: month + rem(months, 12)

  defp adjust_year_and_month(%Ecto.Date{year: year, month: month, day: day}) when month < 1,
    do: %Ecto.Date{year: year - 1, month: month + 12, day: day}
  defp adjust_year_and_month(%Ecto.Date{year: year, month: month, day: day}) when month > 12,
    do: %Ecto.Date{year: year + 1, month: month - 12, day: day}
  defp adjust_year_and_month(date),
    do: date

  defp adjust_day(%Ecto.Date{year: year, month: month, day: _day} = date),
    do: %Ecto.Date{year: year, month: month, day: calculate_day(date)}

  defp calculate_day(%Ecto.Date{year: year, month: month, day: day}),
    do: Enum.min([day, :calendar.last_day_of_the_month(year, month)])
end
