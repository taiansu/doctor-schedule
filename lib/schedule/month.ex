defmodule Schedule.Month do
  alias Schedule.Day
  use Timex

  def generate_month(start_day, holidays \\ []) do
    Interval.new(from: start_day, until: [months: 1])
    |> Interval.with_step(days: 1)
    |> Stream.map(fn date -> {Timex.to_date(date), %Day{}} end)
    |> Stream.map(fn { date, day } -> {date, change_points({ date, day})} end)
    |> Stream.map(fn { date, day } -> { date, set_holidays({ date, day}, holidays)} end)
    |> Map.new()
  end

  def generate_continuous_reserve(start_day, end_day) do
    Interval.new(from: start_day, until: end_day, right_open: false)
    |> Interval.with_step(days: 1)
    |> Stream.map(fn date -> Timex.to_date(date) end)
    |> Enum.to_list
  end

  def generate_reserve_list(year, month, day_list) do
    Enum.map(day_list, fn(number) ->
      Timex.parse!("#{year}-#{month}-#{number}", "{YYYY}-{M}-{D}") |> Timex.to_date
    end)
  end

  def all_points(month_list) do
    Enum.reduce(month_list, 0, fn { day, value }, acc -> value.point + acc end)
  end

  defp change_points({ date, day }) do
    case Timex.weekday(date) do
      5 -> %{day | is_friday: true}
      6 -> %{day | is_holiday: true, point: 2}
      7 -> %{day | is_holiday: true, point: 2}
      _ -> day
    end
  end

  defp set_holidays({date, day}, holidays) do
    if Enum.member?(holidays, date) do
      %{day | is_holiday: true, point: 2}
    else
      day
    end
  end
end
