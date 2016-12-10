defmodule RecurringEvents.TestCase do
  use ExUnit.CaseTemplate

  def using() do
    quote do
      import RecurringEvents.Test.Factory
    end
  end
end
