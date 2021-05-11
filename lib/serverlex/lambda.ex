defmodule Serverlex.Lambda do
  use Ecto.Schema

  schema "lambda" do
    field :name, :string
    field :code, :binary
    timestamps()
  end

end
