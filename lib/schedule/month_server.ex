defmodule Schedule.MonthServer do
  use GenServer
  alias Schedule.Month

  #callback
  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:set_start, date, holidays}, _from, _months) do
    months = Month.generate_month(date, holidays)
    {:reply, months, months}
  end

  def handle_call({:get}, _from, months) do
    {:reply, months, months}
  end
end
