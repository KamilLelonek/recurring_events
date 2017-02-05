defmodule RecurringEvents.Event.Repetition.Mutator do
  use RecurringEvents.Mutator

  alias RecurringEvents.Event.Repetition

  def delete(id) do
    id
    |> Repetition.Queries.by_id()
    |> Repo.delete_all()
  end

  def update(id, params) do
    id
    |> Repetition.Loader.by_id!()
    |> Repetition.Changeset.build(params)
    |> Repo.update()
  end

  def exclude(id, date) do
    ecto_date  = Ecto.Date.cast(date)
    repetition = Repetition.Loader.by_id!(id)
    changeset  = Ecto.Changeset.change(repetition)

    repetition
    |> exclude_date(changeset, ecto_date)
    |> Repo.update()
  end

  defp exclude_date(%Repetition{frequency: :once}, changeset, _date),
    do: Ecto.Changeset.add_error(changeset, :frequency, "Must be other than :once. Only a recurring Repetition can be excluded.")

  defp exclude_date(_repetition, changeset, :error),
    do: Ecto.Changeset.add_error(changeset, :date, "Must be a valid date in format YYYY-MM-DD.")

  defp exclude_date(%Repetition{exclusions: exclusions} = repetition, changeset, {:ok, date}),
    do: maybe_exclude(date in exclusions, changeset, repetition, date)

  defp maybe_exclude(true, changeset, _repetition, date),
    do: Ecto.Changeset.add_error(changeset, :date, "The given date #{date} is already excluded.")

  defp maybe_exclude(false, changeset, repetition, date) do
    repetition
    |> Repetition.Expander.stream()
    |> Enum.any?(&(&1.date == date))
    |> exclude_if_takes_place(changeset, repetition, date)
  end

  defp exclude_if_takes_place(false, changeset, _repetition, date),
    do: Ecto.Changeset.add_error(changeset, :date, "The Event does not oocur at #{date}.")

  defp exclude_if_takes_place(true, changeset, %Repetition{exclusions: exclusions}, date) do
    changeset
    |> Ecto.Changeset.force_change(:exclusions, exclusions)
    |> Ecto.Changeset.update_change(:exclusions, &(&1 ++ [date]))
  end
end
