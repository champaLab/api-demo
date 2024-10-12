#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Configure the GitHub Actions runner
/actions-runner/config.sh --url https://github.com/champaLab/api-demo --token AWVUWBH7M6IIAADF3MJJU63HBJ2WQ

# Start the GitHub Actions runner in the background
/actions-runner/run.sh &

# Start your Node.js application
npm start

# Keep the container running indefinitely
tail -f /dev/null
