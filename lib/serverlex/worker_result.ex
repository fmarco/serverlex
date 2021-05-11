defmodule Serverlex.WorkerResult do
  use Ecto.Schema

  schema "worker_result" do
    field :status, :string
    field :result, :string
    belongs_to :lambda, Serverlex.Lambda
    timestamps()
  end

end
