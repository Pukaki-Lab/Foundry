#!/bin/bash

# Stop script execution on error
set -e

# Accept installation path and project name as arguments
INSTALL_DIR=$1
workspace_name=$2

echo "🚀 Creating Workspace shared components: $workspace_name"

# Create directories (reflecting the project name in directory structure)
mkdir -p "${INSTALL_DIR}/${workspace_name}/"

echo "✅ Directory structure created successfully"
echo "${INSTALL_DIR}/${workspace_name}"


