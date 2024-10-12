#!/bin/bash

# Configure the runner
./config.sh --url $RUNNER_URL --token $RUNNER_TOKEN --unattended --replace

# Start the runner
./run.sh
