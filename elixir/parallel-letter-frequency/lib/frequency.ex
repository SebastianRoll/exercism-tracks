defmodule Worker do
  def start_link do
    Task.start_link(fn -> loop() end)
  end

  defp loop() do
    receive do
      {:work, text, caller} ->
        send caller, Regex.scan(~r/[[:alpha:]]/u, text)
                     |> List.flatten()
                     |> Enum.frequencies_by(&String.downcase/1)
        loop()
    end
  end
end

defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency([], _workers), do: %{}

  def frequency(texts, workers) do
    # todo: how to call start_worker/0?
    # idea: use recursion
    workers = Enum.map(1..workers, fn (_) -> start_worker() end)

    Enum.zip(texts, Stream.cycle(workers))
      |> Enum.map()

    # todo: how to zip modulo the workers list?
    # idea: use recursion while rotating workers list
    [worker | workers] = workers
    pids = texts
      |> Enum.map(&(send_work(&1, worker)))
    Enum.reduce(pids, %{}, fn pid, aggr -> combine(pid, aggr) end)
  end

  defp start_worker() do
    {:ok, pid}  = Worker.start_link
    pid
  end

  defp send_work(text, pid) do
    {:work, _, pid} = send pid, {:work, text, self()}
    pid
  end

  defp combine(_pid, aggr) do
    receive do
      a -> Map.merge(aggr, a, fn _k, v1, v2 -> v1 + v2 end)
    end
  end
end
