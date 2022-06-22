[
  ## all available options with default values (see `mix check` docs for description)
  parallel: true,
  skipped: false,
  retry: false,
  ## list of tools (see `mix check` docs for a list of default curated tools)
  tools: [
    {:credo, "mix credo -a"},
    {:ex_unit, "mix coveralls"},
    {:audit, "mix deps.audit"},
  ]
]
