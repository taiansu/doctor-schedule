defmodule Schedule.Person do
  use Timex

  defstruct current_point: 0,
    holidays_count: 0,
    max_holidays: 1,
    max_points: 8,
    reserve_days: [],
    weekday_reserve: [],
    duty_days: [],
    level: :r1,
    name: "",
    id: :D0000

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
