defmodule Schedule.Day do
  use Timex
  defstruct point: 1, person: Person, is_holiday: false, is_friday: false
end
