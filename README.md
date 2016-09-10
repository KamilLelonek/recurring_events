# recurring_events

[![Build Status](https://travis-ci.org/KamilLelonek/recurring_events.svg?branch=master)](https://travis-ci.org/KamilLelonek/recurring_events)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `recurring_events` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:recurring_events, "~> 0.x"}]
    end
    ```

  2. Ensure `recurring_events` is started before your application:

    ```elixir
    def application do
      [applications: [:recurring_events]]
    end
    ```

## Development

To get and compile all dependencies run:

    mix do deps.get, deps.compile

You can do that each time you pull the repository.

## Database

Firstly, you need to create a database. To do that, execute:

    mix ecto.create

Later on, you may wanna run all migrations. This can be done by:

    mix ecto.migrate

In case of any problems, you can recreate the entire database:

    mix ecto.reset

## Testing

To test the repository you can run:

    mix test [--stale]

This will run the entire test suite and report prospective errors. When you add ` --stale` flag, you will make sure that only changed tests will be run.
