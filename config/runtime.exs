import Config

DotenvParser.load_file(".env")

config :nostrum,
  gateway_intents: :all,
  token: System.get_env("DISCORD_BOT_TOKEN")
