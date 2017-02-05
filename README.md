# recurring_events

[![Build Status](https://travis-ci.org/KamilLelonek/recurring_events.svg?branch=master)](https://travis-ci.org/KamilLelonek/recurring_events)

This is an `Elixir`/`Ecto` library for storing recurring events in your database.

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

    **You don't have to do that in `Elixir >= 1.4`.**

## Usage

### Models

`Event` stores the following fields:

```elixir
@type t :: %RecurringEvents.Event{
  name:        String.t(),
  repetitions: nonempty_list(RecurringEvents.Event.Repetition.t())
}
```

`Repetition` itself is presented as:

```elixir
@type t :: %RecurringEvents.Event.Repetition{
  frequency:  RecurringEvents.Event.Repetition.Frequency.t(),
  interval:   non_neg_integer(),
  start_date: Ecto.Date.t(),
  end_date:   Ecto.Date.t(),
  start_time: Ecto.Time.t(),
  end_time:   Ecto.Time.t(),
  exclusions: list(Ecto.Date.t())
}
```

`Frequency` is an enumerable type:

```elixir
@type t :: %RecurringEvents.Event.Repetition.Frequency{
  value: Enum.t()
}
```

with predefined values:

```elixir
[
  :once,
  :daily,
  :weekly,
  :monthly,
  :yearly
]
```

`Occurrence` is an expanded Event based on its repetition. It's a particular instance of a repeating Event which happens at a specific time and date.

```elixir
@type t :: %RecurringEvents.Event.Repetition.Occurrence{
  event_id:      Ecto.UUID.t(),
  repetition_id: Ecto.UUID.t(),
  date:          Ecto.Date.t(),
  time_start:    Ecto.Time.t(),
  time_end:      Ecto.Time.t(),
}
```

### Structure

The project has the following components:

1. `Loader` - loads records from a repository
2. `Mutator` - stores and updates records in a repository
3. `Changeset` - prepares and validates params for records to be stored in a repoistory
4. `Expander` - expands records based on their repetitions
5. `Schema` - definition of a particular record

### Operations

You can do the following thing with `Event`:

- create
- read / load / query:
  - all: expanded and collapsed
  - one by `ID`: expanded and collapsed
- delete by `ID`
- update (change a name)

On `Repetition` you can do the following:

- update:
  - change start date / time
  - change end date / time
  - exclude a date
  - modify frequency / interval
- delete by `ID`

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

## Linting

There's [`credo`](https://github.com/rrrene/credo) linting mechanizm implemented. To check design, readability or refactoring opportunities you can run:

     mix credo

This will report all suggested changes to be done.
