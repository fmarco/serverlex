defmodule Serverlex.Worker do
  use Task
  require Logger

  def start_link(arg) do
    Task.start_link(__MODULE__, :run, [arg])
  end

  def run(%{
    fun_id: fun_id,
    fun_name: fun_name,
    fun_code: fun_code,
    args: args,
    post_execution_hook: post_execution_hook
  }) when is_map(args) do
    Logger.info("Starting execution for #{fun_name} - PID: #{inspect(self())}")
    #Logger.info(inspect(args))
    args = for {key, value} <- args, into: %{}, do: {String.to_atom(key), value}
    execution_result = case execute_function(fun_code, args) do
      {:ok, result} ->
        # SUCCESS
        post_execution_hook.(%{
          status: "OK",
          result: inspect(result),
          lambda_id: fun_id
        })
        result
      {:error, reason} ->
        # ERROR
        post_execution_hook.(%{
          status: "KO",
          result: inspect(reason),
          lambda_id: fun_id
        })
        reason
    end
    Logger.info("End execution of #{fun_name} task | result: #{inspect(execution_result)} - PID: #{inspect(self())}")
  end

  defp execute_function(fun_code, args) do
    try do
      Logger.debug(args)
      result = fun_code.(args)
      {:ok, result}
    rescue
      err ->
        Logger.error(err)
        {:error, inspect(err)}
    end
  end
end
