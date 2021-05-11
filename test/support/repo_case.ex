defmodule Serverlex.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Serverlex.Repo

      import Ecto
      import Ecto.Query
      import Serverlex.RepoCase

    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Serverlex.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Serverlex.Repo, {:shared, self()})
    end

    :ok
  end
end
