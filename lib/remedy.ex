defmodule RemedySupervisor do
  use Application

  def start(_type, _args) do
    children = [Remedy]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end

defmodule Remedy do
  use Nostrum.Consumer

  alias Nostrum.Api
  alias Nostrum.Struct.Message
  alias Nostrum.Voice
  alias Nostrum.Cache.GuildCache

  def start_link, do: Consumer.start_link(__MODULE__)

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}), do: handle_msg(msg)

  def handle_event(_event), do: :noop

  defp handle_msg(%Message{content: "!ping", channel_id: channel_id}),
    do: Api.create_message(channel_id, "pong")

  defp handle_msg(%Message{content: "!summon"} = msg) do
    case get_voice_channel_from_msg(msg) do
      nil ->
        Api.create_message(msg.channel_id, "You must be in a voice channel to summon")

      voice_channel_id ->
        Voice.join_channel(msg.guild_id, voice_channel_id)
    end
  end

  defp handle_msg(%Message{content: "!leave", guild_id: guild_id}),
    do: Voice.leave_channel(guild_id)

  defp handle_msg(%Message{content: "!pause", guild_id: guild_id}), do: Voice.pause(guild_id)

  defp handle_msg(%Message{content: "!resume", guild_id: guild_id}), do: Voice.resume(guild_id)

  defp handle_msg(%Message{content: "!stop", guild_id: guild_id}), do: Voice.stop(guild_id)

  defp handle_msg(%Message{content: "!play " <> url} = msg) do
    if String.contains?(url, "youtu.be/") or String.contains?(url, "youtube.com/") do
      play_if_voice_ready(msg, url, :ytdl)
    else
      play_if_voice_ready(msg, url, :url)
    end
  end

  defp handle_msg(%Message{content: "!stream " <> url} = msg),
    do: play_if_voice_ready(msg, url, :stream)

  defp handle_msg(_msg), do: :ignore

  defp get_voice_channel_from_msg(msg) do
    msg.guild_id
    |> GuildCache.get!()
    |> Map.get(:voice_states)
    |> Enum.find(%{}, fn voice_state -> voice_state.user_id == msg.author.id end)
    |> Map.get(:channel_id)
  end

  defp play_if_voice_ready(msg, url, playback_type) do
    if Voice.ready?(msg.guild_id) do
      play_audio(msg.guild_id, url, playback_type)
    else
      Api.create_message(msg.channel_id, "I must be in a voice channel to do that")
    end
  end

  defp play_audio(guild_id, url, playback_type) do
    if Voice.playing?(guild_id), do: Voice.stop(guild_id)

    Voice.play(guild_id, url, playback_type)
  end
end
