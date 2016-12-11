defmodule RecurringEvents.Repo.Migrations.CreateRepetitions do
  use Ecto.Migration

  def change do
    create table(:repetitions, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false

      add :frequency,  :string
      add :interval,   :integer
      add :start_date,  :date
      add :end_date,    :date
      add :start_time,  :time
      add :end_time,    :time
      add :exclusions, {:array, :date}

      add :event_id, references(:events, type: :uuid, on_delete: :delete_all)

      timestamps()
    end

    create index(:repetitions, [:event_id])
  end
end
