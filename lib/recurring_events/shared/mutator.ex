defmodule RecurringEvents.Mutator do
  defmacro __using__(_) do
    quote do
      alias RecurringEvents.Repo
    end
  end
end
