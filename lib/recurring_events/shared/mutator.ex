defmodule RecurringEvents.Mutator do
  defmacro __using__(_) do
    quote do
      import Ecto.Query

      alias RecurringEvents.Repo
    end
  end
end
