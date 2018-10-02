defmodule Schedule.Repo.Migrations.CreatePerson do
  use Ecto.Migration

  def change do
    create table(:people, primary_key: false) do
      add :name, :string
      add :level, :integer
      add :doctor_id, :id, primary: true
      add :max_holidays, :integer
      add :max_point, :integer
      add :reserve_days, {:array, :date}
      add :weekday_reserve, {:array, :integer}
      add :duty_days, {:array, :date}
      timestamps()
    end
  end
end
