FROM elixir:1.13.4

WORKDIR /app

RUN apt-get -y update && apt-get install -y \
    ffmpeg \
    python3-pip &&\
    pip install --upgrade streamlink &&\
    ln -s /usr/bin/python3 /usr/bin/python &&\
    curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/bin/youtube-dl &&\
    chmod a+rx /usr/bin/youtube-dl

RUN mix local.hex --force &&\
    mix local.rebar --force

COPY ./mix.exs ./
RUN mix deps.get
COPY ./ ./

ENV MIX_ENV=prod

CMD ["mix", "run", "--no-halt"]
