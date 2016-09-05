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
      aliases:         aliases(),
    ]
  end

  def application do
    [
      mod:          {RecurringEvents, []},
      applications: apps(),
    ]
  end

  defp deps() do
    [
      {:ecto,        "~> 2.0"},
      {:postgrex,    "~> 0.11"},
      {:exnumerator, "~> 1.2"},
    ]
  end

  defp apps() do
    ~w(
      logger
      ecto
      postgrex
      exnumerator
    )a
  end

  defp aliases() do
    [
      "ecto.reset": ["ecto.drop", "ecto.create", "ecto.migrate"],
      "test":       ["ecto.reset", "test"],
    ]
  end
end
