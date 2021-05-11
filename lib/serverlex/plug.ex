defmodule Serverlex.Plug do
  use Plug.Router
  alias Serverlex.Controller

  plug Plug.Logger

  plug :match

  plug Plug.Parsers,
  parsers: [:json],
  json_decoder: Jason

  plug :dispatch

  post "/execute/:lambda_name" do
    lambda_name = (Enum.at(conn.path_info, -1))
    Controller.execute_lambda(lambda_name, conn.body_params)
    send_resp(conn, 200, "Running")
  end

  post "/upload-lambda" do
    %{"name" => name, "code" => code} = conn.body_params
    Controller.add_lambda(name, code)
    send_resp(conn, 200, "Uploaded")
  end

  match _ do
    send_resp(conn, 400, "Bad request")
  end
end
