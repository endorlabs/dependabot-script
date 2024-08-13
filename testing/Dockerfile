FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libffi-dev \            
    libyaml-dev \      
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:longsleep/golang-backports && \
    apt-get update && \
    apt-get install -y golang-go

# Install rbenv and ruby-build
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
# Set up rbenv environment and install Ruby in a single RUN command
RUN export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH" && \
    eval "$(rbenv init -)" && \
    rbenv install 3.2.2 && \
    rbenv global 3.2.2 && \
    gem install bundler

# Debugging: Ensure Ruby is installed
RUN ~/.rbenv/shims/ruby -v
RUN ~/.rbenv/shims/gem -v

# Install Bundler
RUN ~/.rbenv/shims/gem install bundler

# Set the working directory
WORKDIR /app

COPY testing/ /app/

# Build the Go program
RUN go build -o test-go-app

# Copy the ruby files into the container
COPY .ruby-version Gemfile Gemfile.lock /app/

# Copy the generic update script into the container
COPY generic-update-script.rb /app/generic-update-script.rb

# Install dependencies
RUN ~/.rbenv/shims/bundle install

# Provide instructions to the user about how to run the Go application
CMD ["bash"]