FROM elixir:1.13.4

WORKDIR /app

RUN apt-get -y update && apt-get install -y \
    ffmpeg \
    python3-pip

RUN pip install --upgrade streamlink
    
RUN ln -s /usr/bin/python3 /usr/bin/python

RUN pip install --upgrade youtube_dl

RUN mix local.hex --force
RUN mix local.rebar --force

COPY ./ ./
RUN mix deps.get


ENV MIX_ENV=prod

CMD ["mix", "run", "--no-halt"]
