# recurring_events

[![Build Status](https://travis-ci.org/KamilLelonek/recurring_events.svg?branch=master)](https://travis-ci.org/KamilLelonek/recurring_events)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `recurring_events` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:recurring_events, "~> 0.1.0"}]
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

## Database

Firstly, you need to create a database. To do that, execute:

    mix ecto.create

Later on, you may wanna run all migrations. This can be done by:

    mix ecto.migrate
