defmodule Schedule.Resident do
  alias Schedule.Person
  use Ecto.Schema
  schema "residents" do
    has_many :people, {"resident", Person}, foreign_key: :id
  end
end
