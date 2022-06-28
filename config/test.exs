import Config

# Because we don't care, and just want to supress the message in test
config :phoenix, :json_library, Jason

config :crunch_berry, CrunchBerry.TestEndpoint,
  secret_key_base: "oc2RUnRoYkZlR0dM7JwlpbM9AsauRm0R1n+sUP71YsY9eflg4uWyeVFXHrAzDXL7",
  live_view: [signing_salt: "FqRkKpuzaujIZQGN"]

# capture all logs
config :logger, level: :debug

# but only output warnings+ to console.
config :logger, :console, level: :warn
