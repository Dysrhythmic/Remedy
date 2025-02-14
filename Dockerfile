FROM elixir:1.13.4

WORKDIR /app

RUN apt-get -y update && apt-get install -y \
    ffmpeg \
    python3-pip &&\
    ln -s /usr/bin/python3 /usr/bin/python &&\
    pip install --upgrade streamlink youtube_dl

COPY ./ ./

ENV MIX_HOME=/opt/mix
ENV MIX_ENV=prod

RUN mix local.hex --force &&\
    mix local.rebar --force &&\
    mix deps.get &&\
    mix compile

CMD ["mix", "run", "--no-halt"]
