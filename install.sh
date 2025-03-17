#!/bin/bash

# Stop script execution on error
set -e

# Get the current script directory
CURRENT_DIR=$(cd "$(dirname "$0")"; pwd)

# Run the Tuist installation script
bash "$CURRENT_DIR/Tuist-CLI/Environment/setTuist.sh"

echo ""
echo ""

# Prompt for workspace name
echo "💡 Please enter the Xcode Workspace name:"
echo "ex) Apple_Workspace, Notion_Workspace, Pukaki_Lab"
echo ""
read workspace_name

if [ -z "$workspace_name" ]; then
    echo "❌ You must enter a workspace name."
    exit 1
fi

echo ""
echo ""

# Prompt for team name
echo "💡 Please enter the Team Name:"
echo "ex) Apple Inc, Notion, Pukaki Lab"
echo ""
read team_name

if [ -z "$team_name" ]; then
    echo "❌ You must enter a Team name."
    exit 1
fi

echo ""
echo ""

# Prompt for team ID
echo "💡 Please enter the organizer ID:"
echo "ex) com.apple, team.notion lab.pukaki"
echo ""
read team_id

if [ -z "$team_id" ]; then
    echo "❌ You must enter a organizer ID."
    exit 1
fi

echo ""
echo ""


# Prompt for version
echo "💡 Please enter the Workspace Minimum Version:"
echo "ex) 15.0"
echo ""
read minium_version

if [ -z "$minium_version" ]; then
    echo "❌ You must enter a Minimum Version."
    exit 1
fi

echo ""
echo ""

# Prompt for App name
echo "💡 Please enter your first App Service name:"
echo "ex) you can add another services at any time"
echo "ex) Netflix, Airbnb, "
echo ""
read app_name

if [ -z "$app_name" ]; then
    echo "❌ You must enter a app name."
    exit 1
fi

echo ""
echo ""

echo "🔧 Running the project setup script..."
bash "$CURRENT_DIR/Tuist-CLI/Environment/setDirectory.sh" "$CURRENT_DIR" "$workspace_name"

echo ""
echo ""

# Create the Tuist environment directory
PROJECT_DIR="$CURRENT_DIR/$workspace_name"

echo "📂 Creating Tuist Environment directory..."
mkdir -p "$PROJECT_DIR/Tuist"

echo ""
echo ""

# Call the helper file creation script
TUIST_DIR="${PROJECT_DIR}/Tuist"
bash "$CURRENT_DIR/Tuist-CLI/TuistBase/createWorkspace.sh" "$PROJECT_DIR" "$workspace_name" "$team_name" "$app_name"

echo ""
echo ""

# Set helper directory
TUIST_HELPERS_DIR="${PROJECT_DIR}/Tuist/ProjectDescriptionHelpers"

echo ""
echo ""

# Call the helper file creation script
bash "$CURRENT_DIR/Tuist-CLI/TuistBase/createHelpers.sh" "$TUIST_HELPERS_DIR" "$team_id"

echo ""
echo ""

# Set templates directory
TUIST_TEMPLATES_DIR="${PROJECT_DIR}/Tuist/Templates"

# Call the mciro feature template file
bash "$CURRENT_DIR/Tuist-CLI/TuistBase/template-microServiceFeature.sh" "$TUIST_TEMPLATES_DIR" "$minium_version"

# Call the mono feature template file
bash "$CURRENT_DIR/Tuist-CLI/TuistBase/template-monoFeature.sh" "$TUIST_TEMPLATES_DIR" "$minium_version"

# Call the clean feature template file
bash "$CURRENT_DIR/Tuist-CLI/TuistBase/template-cleanFeature.sh" "$TUIST_TEMPLATES_DIR" "$minium_version"

# Call the staticLibrary template file
bash "$CURRENT_DIR/Tuist-CLI/TuistBase/teamplate-staticLibrary.sh" "$TUIST_TEMPLATES_DIR" "$minium_version"

# Call the dynamicFramework template file
bash "$CURRENT_DIR/Tuist-CLI/TuistBase/template-dynamicFramework.sh" "$TUIST_TEMPLATES_DIR" "$minium_version"

# Call the executable template file
bash "$CURRENT_DIR/Tuist-CLI/TuistBase/template-executable.sh" "$TUIST_TEMPLATES_DIR" "$minium_version"

echo ""
echo ""

# Create Makefile
bash "$CURRENT_DIR/Tuist-CLI/Environment/setMakefile.sh" "$PROJECT_DIR" "$team_name"

echo ""
echo ""

# Move to the project directory
cd "$PROJECT_DIR"

# Generate required features and frameworks using Makefile
echo "📦 Set up Shared module..."
echo ""

make framework name=Shared
# mv -f "Shared" "${PROJECT_DIR}/"
echo ""


echo "📦 Set up ${app_name} app..."
echo ""

make app name=${app_name}
echo ""


echo "✅ All shared and app successfully created!"
echo ""


