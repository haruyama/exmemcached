defmodule Exmemcached do
  use Application.Behaviour

  def start(_type, port) do
    Exmemcached.Supervisor.start_link(port)
  end

end
