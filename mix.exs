defmodule Exmemcached.Mixfile do
  use Mix.Project

  def project do
    [ app: :exmemcached,
      version: "0.0.1",
      elixir: "~> 0.10.1",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ registered: [:exmemcached],
    mod: {Exmemcached, 9000} ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "~> 0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    []
  end
end
