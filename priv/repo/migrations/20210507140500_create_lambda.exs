defmodule Serverlex.Repo.Migrations.CreateLambda do
  use Ecto.Migration

  def change do
    create table(:lambda) do
      add :name, :string
      add :code, :binary
      timestamps()
    end
  end
end
