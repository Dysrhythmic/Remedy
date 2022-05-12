FROM elixir:1.13.4

WORKDIR /app

RUN apt-get -y update && apt-get install -y \
    ffmpeg \
    python3-pip

RUN pip install --upgrade streamlink
    
RUN ln -s /usr/bin/python3 /usr/bin/python

RUN curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/bin/youtube-dl &&\
    chmod a+rx /usr/bin/youtube-dl

RUN mix local.hex --force
RUN mix local.rebar --force

COPY ./mix.exs ./
RUN mix deps.get
COPY ./ ./

ENV MIX_ENV=prod

CMD ["mix", "run", "--no-halt"]
