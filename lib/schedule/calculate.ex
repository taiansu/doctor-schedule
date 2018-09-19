defmodule Schedule.Calculate do
  alias Schedule.MonthServer
  alias Schedule.PeopleServer

  @moduledoc"""
  - first, setting up the month
  - setting up all the doctors(a string or a list, pipe into the map with id)
  - setting the points for everyone
  - start calculating from the day1
    - holidays first for all people
    - then arrange all people with friday
    - calculate all the rest day
  - if hit an error, restart again; if restart 100 times, show it was wrong
  - if it all success, show success, and the result
  """

  def set_this_month(date, holidays \\ []) do
    GenServer.call(MonthServer, {:set_start, date, holidays})
  end

  def get_current_month() do
    GenServer.call(MonthServer, {:get})
  end

  def add_new_person(name, id, level, points) do
    GenServer.cast(PeopleServer, {:add, name, id, level, points})
  end

  def set_the_holiday(month, people_list) do
    """
      random pick a person
      check the  reserve_day
      check the weekday_reserve
      if ok ->
        - set the person's duty_day, and add up the current_point
        - set the day with this person
      not ok -> try to repeat 100 times, if still no ok, return with {:error}
    """
  end



end
