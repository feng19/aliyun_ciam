defmodule Aliyun.CIAM.MixProject do
  use Mix.Project

  def project do
    [
      app: :aliyun_ciam,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Aliyun.CIAM.Application, []}
    ]
  end

  defp deps do
    [
      {:tesla, "~> 1.4"},
      {:finch, "~> 0.13"},
      {:jason, "~> 1.4"}
    ]
  end
end
