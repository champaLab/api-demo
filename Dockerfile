# Dockerfile
FROM ubuntu:20.04

# Set environment variables
ENV RUNNER_VERSION=2.320.0
# Specify your desired Node.js version here
ENV NODE_VERSION=18 

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl jq git sudo tar build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - && \
    apt-get install -y nodejs

# Create a directory for the runner
RUN mkdir /actions-runner
WORKDIR /actions-runner

# Download and install the GitHub Actions runner
RUN curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && echo "93ac1b7ce743ee85b5d386f5c1787385ef07b3d7c728ff66ce0d3813d5f46900  actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" | shasum -a 256 -c \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && rm actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Add the configuration script for GitHub Actions runner
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create a directory for your Node.js application
WORKDIR /usr/src/app
COPY package*.json ./

# Install Node.js dependencies
RUN npm install

# Copy the rest of your application files
COPY . .

# Expose the application port (for example, 3000)
EXPOSE 3000

# Set the entrypoint to handle both GitHub Actions runner and Node.js application
ENTRYPOINT ["/entrypoint.sh"]
