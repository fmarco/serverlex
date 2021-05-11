defmodule ServerlexPlugTest do
  use ExUnit.Case
  use Plug.Test
  import Mock

  test "test_add_lambda" do
    conn = conn(:post, "/upload-lambda", Jason.encode!(%{"name" => "testUPLOAD", "code" => "fn args -> args.x + 1 end"}))
    |> put_req_header("content-type", "application/json")
    |> Serverlex.Plug.call(%{})
    assert conn.status == 200
    assert conn.resp_body == ~S(Uploaded)
  end

  test "test_execute_lambda" do
    with_mock(Serverlex.Controller, [execute_lambda: fn _, _ -> nil end]) do
      conn = conn(:post, "/execute/some-lambda", Jason.encode!(%{"x" => 10}))
      |> put_req_header("content-type", "application/json")
      |> Serverlex.Plug.call(%{})
      assert conn.status == 200
      assert conn.resp_body == ~S(Running)
    end
  end

end
