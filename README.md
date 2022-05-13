# Remedy
An Elixir Discord bot made with [Nostrum](https://github.com/Kraigie/nostrum) for playing audio from various sources in voice channels.

## Setup
When run in a dev environment, the app expects a bot token to be provided in a `.env` file in the following format: `DISCORD_BOT_TOKEN="TOKEN_HERE"`. You can add your bot token to the `.env.example` file and rename it to `.env`.

Next you just need to build the Docker image and run it. Use `docker build -f Dockerfile.dev .` to build the image in a dev environment where it is receiving the bot token from the `.env` file. Once built, run it with `docker run -it IMAGE_ID_HERE`. Since the `Dockerfile.dev` file builds the image with a default command to run the app in an `iex` session, the `-it` arguments should be used in the `docker run` command to keep the container open so you can interact with it. If this behavior is undesirable then you can change the line `CMD ["iex", "-S", "mix"]` of the `Dockerfile.dev` file to be `CMD ["mix", "run", "--no-halt"]` instead.

If the bot isn't responding to message commands, ensure privileged gateway intents are enabled for the application in your Discord developer portal.

## Usage
The bot expects commands to be given via message events rather than slash commands. Commands it listens for are:
* `!ping` - Responds with "pong".
* `!summon` - Will find the voice channel the user sending the command is in and joins the channel.
* `!leave` - Will leave the voice channel it is connected to.
* `!play URL_HERE` - Will attempt to play the audio from the given URL. The URL can be [any that ffmpeg can read](https://www.ffmpeg.org/ffmpeg-protocols.html). E.g. `!play music/my favorite song.mp3` will play the file `my favorite song.mp3` if it exists at that path, and `!play http://streams.ilovemusic.de/iloveradio10.mp3` will attempt to play the audio from that HTTP stream.
* `!stream URL_HERE` - Will attempt to stream the audio from the given livestream URL using [streamlink](https://streamlink.github.io/index.html). E.g. `!stream twitch.tv/day9tv` will attempt to stream the audio from [Day9tv's](https://www.twitch.tv/day9tv) Twitch channel.
* `!stop` - Will stop playback.
* `!pause` - Will pause the playback.
* `!resume` - Will resume the playback.

## License
[MIT](https://choosealicense.com/licenses/mit/)