# Use an official Ruby runtime as a parent image
FROM ruby:3.3.2

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y curl postgresql-client && \
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Install Yarn using curl
RUN curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version 1.22.22

# Set Yarn path
ENV PATH="/root/.yarn/bin:/root/.config/yarn/global/node_modules/.bin:${PATH}"

# Set the working directory
WORKDIR /app/server

# Copy the Gemfile and Gemfile.lock into the image
COPY server/Gemfile server/Gemfile.lock /app/server

# Install gems
RUN bundle install

# Copy the rest of the application code
COPY server /app/server

# Install all node modules
RUN yarn install --check-files

# Run database migrations
RUN rails db:migrate

# Set the working directory within the server directory
WORKDIR /app/server

# Ensure logs directory exists and set up proper permissions
RUN mkdir -p tmp/pids tmp/sockets log && \
    chown -R root:root tmp log

# Expose port 3000 to the outside world
EXPOSE 3000

# Start the main process
CMD ["rails", "server", "-b", "0.0.0.0"]
