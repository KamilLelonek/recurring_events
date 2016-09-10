defmodule RecurringEvents.Repo.Migrations.Events do
  use Ecto.Migration

  def change do
    create table(:events, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false

      add :name, :string

      timestamps()
    end
  end
end
