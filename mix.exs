defmodule ExPlay.Mixfile do
  use Mix.Project

  @app      :explay
  @fork     :explay_fork
  @name     "ExPlay"
  @version  "0.1.4"
  @github   "https://github.com/4knahs/#{@app}"


  def project do
    [
      # Project
      app:          @app,
      version:      @version,
      elixir:       "~> 1.2",
      description:  description(),
      package:      package(),
      deps:         deps(),

      # ExDoc
      name:         @name,
      source_url:   @github,
      homepage_url: @github,
      docs: [
        main:       @name,
        canonical:  "https://hexdocs.pm/#{@app}",
        extras:     ["README.md"]
      ]
    ]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [
      {:poison,     "~> 3.0"   },
      {:httpoison,  "~> 0.9.2" },
      {:ex_utils,   ">= 0.0.0" },
      {:ex_doc,     ">= 0.0.0", only: :dev }
    ]
  end

  defp description do
    """
    Google Play (Android Market) API implementation in Elixir
    """
  end

  defp package do
    [
      name:         @fork,
      files:        ~w(mix.exs lib README.md),
      links:        %{"Github" => @github},
      licenses:     ["MIT"],
      maintainers:  ["Sheharyar Naseer"]
    ]
  end
end
