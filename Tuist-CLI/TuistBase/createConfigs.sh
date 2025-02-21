#!/bin/bash

# Stop script execution on error
set -e

# Base path where files will be generated
SRC_ROOT=$1
CONFIGS_DIR=$2
TARGET_NAME=$3

if [ -z "$CONFIGS_DIR" ]; then
    echo "❌ You must provide a directory path for file creation."
    exit 1
fi

if [ -z "$TARGET_NAME" ]; then
    echo "❌ You must provide a target name for file creation."
    exit 1
fi

# Create the directory
mkdir -p "$CONFIGS_DIR"

# Generate the Common.xcconfig
echo "📄 Creating Common.xcconfig file..."
cat <<EOF > "$CONFIGS_DIR/Common.xcconfig"
SWIFT_VERSION = 6.0
ENABLE_BITCODE = NO
CODE_SIGN_STYLE = Automatic
VERSIONING_SYSTEM = apple-generic
GCC_C_LANGUAGE_STANDARD = gnu99
CLANG_CXX_LANGUAGE_STANDARD = gnu++17
CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = NO
EOF

# Generate the Modules-Debug.xcconfig
echo "📄 Creating CommModules-Debugon.xcconfig file..."
cat <<EOF > "$CONFIGS_DIR/Modules-Debug.xcconfig"
#include "Common.xcconfig"

INFOPLIST_FILE = ${SRC_ROOT}/Tuist/Configs/Modules-Debug-Info.plist
GCC_OPTIMIZATION_LEVEL = 0
SWIFT_OPTIMIZATION_LEVEL = -Onone
OTHER_SWIFT_FLAGS = -DDEBUG
ENABLE_DEBUG_MODE = YES
EOF

# Generate the Modules-Release.xcconfig
echo "📄 Creating CommModules-Release.xcconfig file..."
cat <<EOF > "$CONFIGS_DIR/Modules-Release.xcconfig"
#include "Common.xcconfig"

INFOPLIST_FILE = ${SRC_ROOT}/Tuist/Configs/Modules-Release-Info.plist
GCC_OPTIMIZATION_LEVEL = s
SWIFT_OPTIMIZATION_LEVEL = -Owholemodule
OTHER_SWIFT_FLAGS = -DRELEASE
ENABLE_DEBUG_MODE = NO
EOF




