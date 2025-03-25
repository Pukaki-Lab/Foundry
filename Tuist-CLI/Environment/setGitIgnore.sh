#!/bin/bash

# Set the path for the .gitignore file
ROOT_DIR=$1

echo "📄 .gitignore file..."
cat <<EOL > "$ROOT_DIR/.gitignore"
# Tuist 관련
/.build/
/Derived/
/ProjectDescriptionHelpers/.build/
/Tuist/Dependencies
/Tuist/Graph
graph.*

# Xcode 관련
DerivedData/
/*.xcworkspace
/*.xcodeproj
xcuserdata/
*.xcuserstate
*.xccheckout
*.moved-aside

# 빌드 산출물
build/
*.o
*.LinkFileList
*.hmap
*.ipa
*.app

# Swift Package Manager
.swiftpm/
Package.resolved
.build/

# 사용자 설정 및 기타
*.DS_Store
*.swp
*.lock
*.log
.idea/
.vscode/
.env

# Xcode Playground
timeline.xctimeline
playground.xcworkspace

EOL

echo "✅ .gitignore file file created successfully"
echo "$ROOT_DIR/.gitignore"
echo ""

