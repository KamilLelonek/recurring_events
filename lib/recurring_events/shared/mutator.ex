defmodule RecurringEvents.Mutator do
  defmacro __using__(_) do
    quote do
      import Ecto
      import Ecto.Changeset

      alias RecurringEvents.Repo
    end
  end
end
