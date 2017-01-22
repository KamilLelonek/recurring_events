defmodule RecurringEvents.Event.Loader do
  use RecurringEvents.Loader

  alias RecurringEvents.Event.{Expander, Queries}

  def all(:expanded) do
    Queries.all_with_associations()
    |> Repo.all()
    |> Enum.map(&Expander.run/1)
  end

  def all(:collapsed),
    do: Repo.all(Queries.all_with_associations())

  def one!(:expanded, id) do
    id
    |> Queries.by_id_with_associations()
    |> Repo.one!()
    |> Expander.run()
  end

  def one!(:collapsed, id) do
    id
    |> Queries.by_id_with_associations()
    |> Repo.one!()
  end
end
