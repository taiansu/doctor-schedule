defmodule Schedule.Day do
  use Timex
  use Ecto.Schema
  import Ecto.Changeset
  # defstruct point: 1, person: :D0000, is_holiday: false, is_friday: false

  @primary_key {:date_id, :date, autogenerate: false}
  schema "day" do
    field :point, :integer, default: 1
    field :is_holiday, :boolean, default: false
    field :is_friday, :boolean, default: false
    belongs_to :resident, Schedule.Resident
    belongs_to :attending, Schedule.Attending

    timestamps()
  end


  def changeset(day, params \\ %{}) do
    day
    |> cast(params, [:point, :is_friday, :is_holiday])
    |> validate_required([:date_id])
  end


end
