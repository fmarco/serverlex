defmodule Serverlex.Controller do
  import Ecto.Query
  alias Serverlex.{Lambda, WorkerResult, Repo}

  @moduledoc """
  Handle generic operations on lambda
  """

  @doc """
  Add a new lambda function
  """
  def add_lambda(
    name,
    function_definition
  ) when is_function(function_definition) do
    # convert the function definition in a binary
    binary_code = :erlang.term_to_binary(function_definition)
    lambda = %Lambda{
      name: name,
      code: binary_code
    }
    Repo.insert(lambda)
  end

  @doc """
  Add a new lambda function
  """
  def add_lambda(
    name,
    function_definition
  ) when is_binary(function_definition) do
    {function_definition, _} = Code.eval_string(function_definition)
    add_lambda(name, function_definition)
  end

  @doc """
  Retrieve a lambda function by name
  """
  def get_lambda(name) do
    Repo.one!(from lb in Lambda, where: lb.name == ^name)
  end

  @doc """
  Load a lambda function definition given its name.
  The lambda id is also returned.
  """
  def load_lambda_code(name) do
    case get_lambda(name) do
      %Lambda{id: id, code: code} ->
        %{
          id: id,
          code: :erlang.binary_to_term(code)
        }
      _ -> nil
    end
  end

  @doc """
  Save the result of a lambda execution
  """
  def add_worker_result(
    %{
      status: status,
      result: result,
      lambda_id: lambda_id
    }) do
      IO.puts(result)
      Repo.insert(
        %WorkerResult{
          status: status,
          result: result,
          lambda_id: lambda_id
        }
      )
  end

  @doc """
  Retieve execution results of a single lambda given its id
  """
  def get_worker_result(lambda_id) do
    Repo.all(
      from wr in WorkerResult, where: wr.lambda_id == ^lambda_id
    )
  end

  @doc """
  Run a lambda in a separate Task process
  """
  def execute_lambda(lambda_name, lambda_arguments) do
    %{
      id: lambda_id,
      code: lambda_code
    } = load_lambda_code(lambda_name)
    # run the lambda inside a supervised task
    Task.Supervisor.start_child(
      # dynamic supervisor
      Serverlex.TaskSupervisor,
      # worker module
      Serverlex.Worker,
      # worker run function
      :run,
      # worker run function arguments
      [
        %{
          fun_id: lambda_id,
          fun_name: lambda_name,
          fun_code: lambda_code,
          args: lambda_arguments,
          post_execution_hook: &add_worker_result/1
        }
      ]
    )
  end
end
