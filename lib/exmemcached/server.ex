# oritinal: http://dsas.blog.klab.org/archives/51094713.html
defmodule Exmemcached.Server do

  def start_link(port) do
    :gen_server.start_link({:local, :exmemcached}, __MODULE__, port, [])
  end

  def init(port) do
    :ets.new(:item, [:public, :named_table])
    {:ok, listen} = :gen_tcp.listen(port,  [:binary, {:packet, :line}, {:active, false}, {:reuseaddr, true}])
    IO.puts "listening port: #{port}"
    accept(listen)
  end

  def accept(listen) do
    {:ok, sock} = :gen_tcp.accept(listen)
    IO.puts "new client connection\n"
    spawn(__MODULE__, :process_command, [sock])
    accept(listen)
  end

  def process_command(sock) do
    case :gen_tcp.recv(sock, 0) do
      {:ok, line} ->
#         IO.puts "#{line}"
        token = String.split(String.strip(line))
#         IO.puts "#{inspect(token)}"
        case token do
          ["get", key] -> 
            process_get(sock, key)
          ["set", key, value] ->
            process_set(sock, key, value)
          _ ->
            IO.puts "Unknown command: #{line}"
            :gen_tcp.send(sock, "UNKNOWN COMMAND\r\n")
        end
        process_command(sock)
      {:error, :closed} ->
        IO.puts "closed"
      Error ->
        IO.puts "Error"
    end
  end

  def process_get(sock, key) do
    case :ets.lookup(:item, key) do
      [{_, value}] ->
        :gen_tcp.send(sock, "VALUE: #{value}\r\n")
      [] ->
        :gen_tcp.send(sock, "NOT FOUND\r\n")
    end
  end

  def process_set(sock, key, value) do
    :ets.insert(:item, {key, value})
    :gen_tcp.send(sock, "STORED: #{key} #{value}\r\n")
  end
end
