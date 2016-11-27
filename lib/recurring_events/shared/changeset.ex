defmodule RecurringEvents.Changeset do
  defmacro __using__(_) do
    quote do
      import Ecto
      import Ecto.Changeset

      alias RecurringEvents.Repo

      def fetch_fields(build, fields) do
        Enum.map(
          fields,
          &fetch_single_field(&1, build)
        )
      end

      defp fetch_single_field(field_to_fetch, build) do
        build
        |> fetch_field(field_to_fetch)
        |> single_field()
      end

      defp single_field(:error),     do: nil
      defp single_field({_, field}), do: field
    end
  end
end
