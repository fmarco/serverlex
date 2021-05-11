defmodule Serverlex.Repo do
  use Ecto.Repo,
    otp_app: :serverlex,
    adapter: Ecto.Adapters.Postgres
end
