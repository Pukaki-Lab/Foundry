#!/bin/bash

# Stop script execution on error
set -e

# Check if Tuist is installed
echo "🔍 Checking if Tuist is installed..."
if ! command -v tuist &> /dev/null; then
    echo "🚀 Tuist is not installed. Starting installation..."
    curl -Ls https://install.tuist.io | bash
    echo "✅ Tuist has been successfully installed."
else
    echo "✅ Tuist is already installed."
fi