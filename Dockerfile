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

# Install Go
RUN add-apt-repository ppa:longsleep/golang-backports && \
    apt-get update && \
    apt-get install -y golang-go

# Install RVM and Ruby
RUN gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN curl -sSL https://get.rvm.io | bash -s stable && \
    /bin/bash -c "source /etc/profile.d/rvm.sh && rvm install 3.2.2 && rvm use 3.2.2 --default"

# Set up RVM environment
ENV PATH /usr/local/rvm/gems/ruby-3.2.2/bin:/usr/local/rvm/rubies/ruby-3.2.2/bin:$PATH
ENV GEM_HOME /usr/local/rvm/gems/ruby-3.2.2
ENV GEM_PATH /usr/local/rvm/gems/ruby-3.2.2

# Debugging: Ensure Ruby and Bundler are installed
RUN ruby -v
RUN gem -v

# Install Bundler
RUN gem install bundler

# Set the working directory
WORKDIR /app

# Copy the application files into the container
COPY testing/ /app/
COPY .ruby-version Gemfile Gemfile.lock /app/
COPY generic-update-script.rb /app/generic-update-script.rb

# Build the Go program
RUN go build -o test-go-app

# Install Ruby dependencies
RUN bundle install

# Provide instructions to the user about how to run the Go application
CMD ["bash"]

