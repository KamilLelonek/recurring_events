defmodule RecurringEvents.Queries do
  defmacro __using__(_) do
    quote do
      import Ecto.Query
    end
  end
end
