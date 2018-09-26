defmodule Schedule.Day do
  use Timex
  defstruct point: 1, person: :D0000, is_holiday: false, is_friday: false
end
