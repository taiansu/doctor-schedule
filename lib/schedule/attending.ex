defmodule Schedule.Attending do
  alias Schedule.Person
  use Ecto.Schema

  schema "attendings" do
    has_many(:people, {"attending", Person}, foreign_key: :id)
  end
end
