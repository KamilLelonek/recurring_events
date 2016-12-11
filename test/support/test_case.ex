defmodule RecurringEvents.TestCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import RecurringEvents.{TestCase, Test.Factory}
    end
  end
end
