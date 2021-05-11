defmodule ServerlexControllerTest do
  use ExUnit.Case
  use Serverlex.RepoCase
  import Mock
  alias Serverlex.{Repo, Controller, Lambda}


  test "test_add_lambda" do
    assert Repo.one(from l in Lambda, select: count(l.id)) == 0
    lambda_name = "test_lambda"
    lambda_definition = fn x -> x + 1 end
    Controller.add_lambda(
      lambda_name,
      lambda_definition
    )
    assert Repo.one(from l in Lambda, select: count(l.id)) == 1
    inserted_lambda = Repo.one(
      from l in Lambda, limit: 1, order_by: [desc: l.inserted_at]
    )
    assert  Controller.get_lambda(lambda_name) == inserted_lambda

    lambda_code = :erlang.binary_to_term(inserted_lambda.code)
    assert lambda_definition == lambda_code
    assert lambda_code == Controller.load_lambda_code(lambda_name).code
  end

  test "execute_lambda" do
    lambda_name = "test_lambda_bis"
    lambda_definition =
      fn args ->
        args.x + args.x
      end
    Controller.add_lambda(
      lambda_name,
      lambda_definition
    )
    {:ok, pid} = Controller.execute_lambda(lambda_name, %{"x" => 8})
    assert(Process.alive?(pid))
    Controller.load_lambda_code(lambda_name).id
    |> Controller.get_worker_result()
  end

end
