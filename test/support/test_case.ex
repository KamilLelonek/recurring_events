defmodule RecurringEvents.TestCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias RecurringEvents.Repo

      import RecurringEvents.{TestCase, Test.Factory}
    end
  end

  setup(_) do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(RecurringEvents.Repo)
  end

  def errors_on_create(params, schema, changeset) do
    params = Enum.into(params, %{})

    schema
    |> Map.merge(params)
    |> changeset.build()
    |> Ecto.Changeset.traverse_errors(&(&1))
  end
end
