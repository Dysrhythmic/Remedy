import Config

if Config.config_env() == :dev do
  DotenvParser.load_file(".env")
end

config :nostrum,
  gateway_intents: :all,
  token: System.get_env("DISCORD_BOT_TOKEN")
