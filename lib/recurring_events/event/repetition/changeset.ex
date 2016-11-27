defmodule RecurringEvents.Event.Repetition.Changeset do
  use RecurringEvents.Changeset

  alias RecurringEvents.Event.Repetition
  alias RecurringEvents.Event.Repetition.Frequency

  @params_required ~w(frequency interval start_date end_date start_time end_time)a
  @params_optional ~w(exclusions)a

  def build(schema \\ %Repetition{}, params) do
    schema
    |> cast(params, @params_required ++ @params_optional)
    |> validate_required(@params_required)
    |> validate_params()
    |> validate_business_rules()
  end

  defp validate_params(build) do
    build
    |> validate_inclusion(:frequency, Frequency.values())
    |> validate_number(:interval, greater_than_or_equal_to: 0)
  end

  defp validate_business_rules(%Ecto.Changeset{valid?: false} = build),
    do: build

  defp validate_business_rules(build) do
    {_, frequency}  = fetch_field(build, :frequency)
    {_, interval}   = fetch_field(build, :interval)
    {_, start_date} = fetch_field(build, :start_date)
    {_, end_date}   = fetch_field(build, :end_date)
    {_, start_time} = fetch_field(build, :start_time)
    {_, end_time}   = fetch_field(build, :end_time)

    validate_business_rules(build, frequency, interval, start_date, end_date, start_time, end_time)
  end

  defp validate_business_rules(build, _frequency, _interval, date, date, start_time, end_time) do
    with :lt <- Ecto.Time.compare(start_time, end_time) do
        build
      else
        _ -> add_error(build, :start_time, "must be less than :end_time for the same dates")
    end
  end

  defp validate_business_rules(build, :once, interval, _start_date, _end_date, _start_time, _end_time)
  when interval != 0,
    do: add_error(build, :interval, "must be 0 for frequency :once")

  defp validate_business_rules(build, frequency, 0, _start_date, _end_date, _start_time, _end_time)
  when frequency != :once,
    do: add_error(build, :frequency, "must occur only :once for :interval 0")

  defp validate_business_rules(build, _frequency, _interval, start_date, end_date, _start_time, _end_time) do
    with :lt <- Ecto.Date.compare(start_date, end_date) do
        build
      else
        _ -> add_error(build, :start_date, "must be less or equal to :end_date")
    end
  end
end
