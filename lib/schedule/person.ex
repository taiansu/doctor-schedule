defmodule Schedule.Person do
  use Timex
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:doctor_id, :id, autogenerate: false}
  schema "people" do
    field :current_point, :integer, virtual: true, default: 0
    field :holidays_count, :integer, virtual: true,  default: 0
    field :max_holidays, :integer, default: 0
    field :max_point, :integer, default: 8
    field :reserve_days, { :array, :date}
    field :weekday_reserve, { :array, :date }
    field :duty_days, { :array, :date }
    field :level, :integer
    field :name, :string

    timestamps()
 end

  def resident_changeset(person, params \\ %{}) do
    person
    |> cast(params, [:name, :level,:doctor_id, :holidays_count, :max_holidays, :max_point, :reserve_days, :weekday_reserve, :duty_days, :current_point, :holidays_count])
    |> validate_required([:name, :level, :doctor_id])
  end

# defstruct current_point: 0,
#     holidays_count: 0,
#  max_holidays: 1,
#     max_points: 8,
#     reserve_days: [],
#     weekday_reserve: [],
#     duty_days: [],
#     level: :r1,
#     name: "",
#     id: :D0000

  def convert_weekday_to_day(person, start_day) do
    pick =
      Interval.new(from: start_day, until: [months: 1])
      |> Stream.filter(fn day ->
        Enum.member?(person.weekday_reserve, Timex.weekday(day))
      end)
      |> Enum.map(fn day -> Timex.to_date(day) end)

    %{person | reserve_days: person.reserve_days |> Stream.concat(pick) |> Enum.uniq()}
  end

  def setting_point(total_points, max_point) do
    sum = total_points - max_point
    if sum > 0 do
      "everyone on should add more points: #{sum}"
    else
      "everyone should reduce points: #{sum}"
    end
  end

  def r1(person), do: %{person | max_point: 7}
  def r2(person), do: %{person | max_point: 6}
  def r3(person), do: %{person | max_point: 5}
  def r4(person), do: %{person | max_point: 4}

end
