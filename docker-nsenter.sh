#!/bin/bash

#===============================================================================
# Script Name: enter_container_namespace.sh
# Author: Created with pride by ChatGPT for obeone (https://github.com/obeone)
# Date: $(date +"%Y-%m-%d")
# Version: 1.0
# 
# Description:
# This script allows you to enter the namespace of a running Docker container 
# by utilizing the 'nsenter' command. You can pass any valid nsenter options 
# (e.g., --net, --mount, etc.) to execute commands in the desired namespace.
# 
# Usage:
#   enter_container_namespace.sh [nsenter options] <container_name>
#   
# Arguments:
#   [nsenter options]   Any valid nsenter options to pass (e.g. -m, -n, --mount, --net, etc.)
#   <container_name>    Docker container name or ID
# 
# Example:
#   enter_container_namespace.sh -n my_container
#   enter_container_namespace.sh --mount=/mnt/my_mount my_container
#
# Requirements:
#   - Docker must be installed and running.
#   - The 'nsenter' command must be available.
#   - The user must have sudo privileges.
#
# License:
# MIT License
# 
# Copyright (c) Grégoire Compagnon
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#===============================================================================

# Enable strict error handling
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Usage function to display help
usage() {
  echo -e "${YELLOW}Usage: $0 [nsenter options] <container_name>${NC}"
  echo -e "  [nsenter options]   Any valid nsenter options to pass (e.g. -m, -n, --mount, --net, etc.)"
  echo -e "  <container_name>    Docker container name or ID"
  echo -e "\nExamples:"
  echo -e "  $0 -n my_container"
  echo -e "  $0 --mount=/mnt/my_mount my_container"
  exit 1
}

# Ensure at least one argument is passed
if [[ "$#" -lt 1 ]]; then
  usage
fi

# Function for logging messages
log() {
  local COLOR="$1"
  local MESSAGE="$2"
  echo -e "${COLOR}${MESSAGE}${NC}"
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
  log "$RED" "Error: The 'docker' command is not found. Please install Docker."
  exit 1
fi

# Check if the Docker daemon is running
if ! docker info &> /dev/null; then
  log "$RED" "Error: The Docker daemon does not seem to be running. Please start it."
  exit 1
fi

# Check if 'nsenter' is installed
if ! command -v nsenter &> /dev/null; then
  log "$RED" "Error: The 'nsenter' command is not found. Please install nsenter to use this script."
  exit 1
fi

# Check if the user has sudo privileges
if ! sudo -v &> /dev/null; then
  log "$RED" "Error: You do not have the necessary sudo privileges to run this script."
  exit 1
fi

# Collect the nsenter options and get the container name (last argument)
NSENTER_OPTIONS=()
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      ;;
    --*=*)
      NSENTER_OPTIONS+=("$1")
      shift
      ;;
    -*)
      NSENTER_OPTIONS+=("$1")
      if [[ "$1" =~ ^-(S|G)$ && "$#" -gt 1 && ! "$2" =~ ^- ]]; then
        NSENTER_OPTIONS+=("$2")
        shift
      fi
      shift
      ;;
    *)
      CONTAINER_NAME="$1"
      shift
      ;;
  esac
done

# Check if the container name is provided
if [[ -z "${CONTAINER_NAME:-}" ]]; then
  usage
fi

# Get the PID of the container
set +e
CONTAINER_PID=$(docker inspect --format '{{.State.Pid}}' "$CONTAINER_NAME" 2>/dev/null)
if [[ $? -ne 0 ]]; then
  log "$RED" "Error: Failed to inspect the container '$CONTAINER_NAME'. Ensure the container exists."
  exit 1
fi
set -e

if [[ -z "$CONTAINER_PID" || "$CONTAINER_PID" == "0" ]]; then
  log "$RED" "Error: Unable to find the PID for container '$CONTAINER_NAME'. Ensure the container is running."
  exit 1
fi

# Inform the user
log "$GREEN" "Entering namespace of container '$CONTAINER_NAME' (PID: $CONTAINER_PID)..."

# Execute nsenter with the provided options
if ! sudo nsenter --target "$CONTAINER_PID" "${NSENTER_OPTIONS[@]}"; then
  log "$RED" "Error: Failed to execute nsenter. Ensure you have the necessary permissions."
  exit 1
fi
