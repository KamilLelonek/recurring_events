defmodule RecurringEvents.Event.Repetition.MutatorTest do
  use RecurringEvents.TestCase, async: true

  alias RecurringEvents.Event.Repetition.Mutator

  setup do
    %{id: id} = insert(:repetition)

    {:ok, id: id}
  end

  describe "exclude" do
    @date_to_exclude "2020-01-01"

    test "should exclude a valid date", %{id: id} do
      {:ok, %{exclusions: [_, excluded_date]}} = Mutator.exclude(id, @date_to_exclude)

      assert excluded_date == Ecto.Date.cast!(@date_to_exclude)
    end

    test "should not exclude any date for frequency :once" do
      %{id: id} = insert(:repetition, frequency: :once)

      refute_excluded(id, @date_to_exclude, "Must be other than :once. Only a recurring Repetition can be excluded.", :frequency)
    end

    test "should not exclude an already excluded date", %{id: id} do
      {:ok, %{exclusions: [excluded_date, _]}} = Mutator.exclude(id, @date_to_exclude)

      refute_excluded(id, excluded_date, "The given date #{excluded_date} is already excluded.")
    end

    test "should not exclude a nonexistent occurrence", %{id: id} do
      date_to_exclude = "2020-01-02"

      refute_excluded(id, date_to_exclude, "The Event does not oocur at #{date_to_exclude}.")
    end

    test "should not exclude an invalid date", %{id: id} do
      refute_excluded(id, "13-13-1313", "Must be a valid date in format YYYY-MM-DD.")
    end

    defp refute_excluded(id, date_to_exclude, message, error \\ :date) do
      {:error, %{errors: errors}} = Mutator.exclude(id, date_to_exclude)

      assert {error, {message, []}} in errors
    end
  end

  describe "delete" do
    test "should remove a single Repetition", %{id: id} do
      {1, nil} = Mutator.delete(id)
    end

    test "should not remove a Repetition" do
      {0, nil} = Mutator.delete(Ecto.UUID.generate())
    end
  end

  describe "update" do
    test "should update frequency", %{id: id} do
      assert {:ok, %{frequency: :monthly}} = Mutator.update(id, %{frequency: :monthly})
    end

    test "should not update an invalid frequency", %{id: id} do
      assert {:error, %Ecto.Changeset{errors: errors}} = Mutator.update(id, %{frequency: :once})
      assert errors == [interval: {"must be 0 for frequency :once", []}]

      assert {:error, %Ecto.Changeset{errors: errors}} = Mutator.update(id, %{frequency: :x})
      assert errors == [frequency: {"is invalid", [type: RecurringEvents.Event.Repetition.Frequency, validation: :cast]}]
    end

    test "should update interval", %{id: id} do
      assert {:ok, %{interval: 10}} = Mutator.update(id, %{interval: 10})
    end

    test "should not update an invalid interval", %{id: id} do
      assert {:error, %Ecto.Changeset{errors: errors}} = Mutator.update(id, %{interval: 0})
      assert errors == [frequency: {"must occur only :once for :interval 0", []}]

      assert {:error, %Ecto.Changeset{errors: errors}} = Mutator.update(id, %{interval: -1})
      assert errors == [interval: {"must be greater than or equal to %{number}", [validation: :number, number: 0]}]
    end

    test "should update start_date", %{id: id} do
      assert {:ok, %{start_date: %Ecto.Date{year: 1000, month: 1, day: 1}}} = Mutator.update(id, %{start_date: "1000-01-01"})
    end

    test "should not update an invalid start_date", %{id: id} do
      assert {:error, %Ecto.Changeset{errors: errors}} = Mutator.update(id, %{start_date: "3000-01-01"})
      assert errors == [start_date: {"must be less or equal to :end_date", []}]

      assert {:error, %Ecto.Changeset{errors: errors}} = Mutator.update(id, %{start_date: "01-01-2000"})
      assert errors == [start_date: {"is invalid", [type: Ecto.Date, validation: :cast]}]
    end

    test "should update end_date", %{id: id} do
      assert {:ok, %{end_date: %Ecto.Date{year: 3000, month: 1, day: 1}}} = Mutator.update(id, %{end_date: "3000-01-01"})
    end

    test "should not update an invalid end_date", %{id: id} do
      assert {:error, %Ecto.Changeset{errors: errors}} = Mutator.update(id, %{end_date: "1000-01-01"})
      assert errors == [start_date: {"must be less or equal to :end_date", []}]

      assert {:error, %Ecto.Changeset{errors: errors}} = Mutator.update(id, %{end_date: "01-01-2000"})
      assert errors == [end_date: {"is invalid", [type: Ecto.Date, validation: :cast]}]
    end

    test "should update start_time", %{id: id} do
      assert {:ok, %{start_time: %Ecto.Time{hour: 0, min: 0, sec: 0}}} = Mutator.update(id, %{start_time: "00:00:00"})
    end

    test "should not update an invalid start_time", %{id: id} do
      assert {:error, %Ecto.Changeset{errors: errors}} = Mutator.update(id, %{start_time: "30:00:00"})
      assert errors == [start_time: {"is invalid", [type: Ecto.Time, validation: :cast]}]

      Mutator.update(id, %{start_date: params_for(:repetition)[:end_date]})

      assert {:error, %Ecto.Changeset{errors: errors}} = Mutator.update(id, %{start_time: "01:00:00"})
      assert errors == [start_time: {"must be less than :end_time for the same dates", []}]
    end

    test "should update end_time", %{id: id} do
      assert {:ok, %{end_time: %Ecto.Time{hour: 0, min: 0, sec: 0}}} = Mutator.update(id, %{end_time: "00:00:00"})
    end

    test "should not update an invalid end_time", %{id: id} do
      assert {:error, %Ecto.Changeset{errors: errors}} = Mutator.update(id, %{end_time: "30:00:00"})
      assert errors == [end_time: {"is invalid", [type: Ecto.Time, validation: :cast]}]

      Mutator.update(id, %{end_date: params_for(:repetition)[:start_date]})

      assert {:error, %Ecto.Changeset{errors: errors}} = Mutator.update(id, %{end_time: "00:00:00"})
      assert errors == [start_time: {"must be less than :end_time for the same dates", []}]
    end
  end
end
