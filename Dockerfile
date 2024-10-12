# Use an official Ubuntu as a base image
FROM ubuntu:20.04

# Set environment variables to make installation non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    jq \
    sudo \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    python3-pip \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    && apt-get clean

# Install Node.js and Yarn
RUN curl -sL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g yarn

# Set up GitHub Actions Runner
RUN mkdir -p /actions-runner && cd /actions-runner \
    && curl -o actions-runner-linux-x64.tar.gz -L https://github.com/actions/runner/releases/download/v2.305.0/actions-runner-linux-x64-2.305.0.tar.gz \
    && tar xzf ./actions-runner-linux-x64.tar.gz

# Set up GitHub Actions Runner token and URL as environment variables
ENV RUNNER_TOKEN=AWVUWBDSRADHCWRJPGVV7KTHBKFPW
ENV RUNNER_URL=https://github.com/champaLab/api-demo

# Install runner dependencies
RUN /actions-runner/bin/installdependencies.sh

# Copy start script into the container
COPY start.sh /actions-runner/start.sh
RUN chmod +x /actions-runner/start.sh

WORKDIR /actions-runner

# Start the runner
ENTRYPOINT ["./start.sh"]


