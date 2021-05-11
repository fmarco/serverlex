defmodule Serverlex.Repo.Migrations.CreateWorkerResult do
  use Ecto.Migration

  def change do
    create table(:worker_result) do
      add :status, :string
      add :result, :string
      add :lambda_id, references(:lambda, on_delete: :nilify_all)
      timestamps()
    end
  end
end
