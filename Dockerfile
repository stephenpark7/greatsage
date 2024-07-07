FROM ruby:3.3.2

RUN apt-get update -qq && \
    apt-get install -y curl postgresql-client

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

WORKDIR /app/server

COPY server/Gemfile server/Gemfile.lock .

RUN bundle install

# Ensure logs directory exists and set up proper permissions
RUN mkdir -p tmp/pids tmp/sockets log && \
    chown -R root:root tmp log

WORKDIR /app/client

COPY client .

RUN npm install

WORKDIR /app

EXPOSE 3000 3001
