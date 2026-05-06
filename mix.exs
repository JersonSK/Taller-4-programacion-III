defmodule Gimnasio.MixProject do
  use Mix.Project

  def project do
    [
      app: :gimnasio,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Gimnasio.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end
end
