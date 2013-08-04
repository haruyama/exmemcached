defmodule Exmemcached.Supervisor do
  use Supervisor.Behaviour

  def start_link(port) do
    :supervisor.start_link(__MODULE__, port)
  end

  def init(port) do
    childlen = [worker(Exmemcached.Server, [port])]
    supervise childlen, strategy: :one_for_one
  end
end
