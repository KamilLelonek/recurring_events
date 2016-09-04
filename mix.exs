defmodule RecurringEvents.Mixfile do
  use Mix.Project

  def project do
    [
      app:             :recurring_events,
      build_embedded:  Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      elixir:          "~> 1.3",
      version:         "0.1.0",
      deps:            deps(),
    ]
  end

  def application do
    [
      applications: apps(),
    ]
  end

  defp deps() do
    []
  end

  defp apps() do
    []
  end
end
