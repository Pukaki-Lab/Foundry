#!/bin/bash

# Stop script execution on error
set -e

PROJECT_DIR=$1
TEAM=$2

# Check if TEAM argument is provided
if [ -z "$TEAM" ]; then
    echo "❌ Usage: setup.sh <PROJECT_DIR> <TEAM>"
    exit 1
fi

echo "📂 PROJECT_DIR set to: $PROJECT_DIR"

# Makefile 생성
cat > "$PROJECT_DIR/Makefile" <<EOF
TEMPLATE_DIR := ./Tuist/Templates
AUTHOR := \$(shell git config user.name)
YEAR := \$(shell date +%Y)
ORG := ${TEAM}

PROJECT_DIR := \$(shell pwd)

define scaffold_micro_feature
	@echo "🚀 Generating MicroFeature: \$(1)"
	tuist scaffold microFeature --name \$(1) --date \$(shell date +"%-m/%-d/%y") --author "\$(AUTHOR)" --year "\$(YEAR)" --organization "\$(ORG)"
endef

define scaffold_framework
	@echo "🚀 Generating framework: \$(1)"
	tuist scaffold dynamicFramework --name \$(1) --date \$(shell date +"%-m/%-d/%y") --author "\$(AUTHOR)" --year "\$(YEAR)" --organization "\$(ORG)"
endef

define scaffold_library
	@echo "🚀 Generating library: \$(1)"
	tuist scaffold staticLibrary --name \$(1) --date \$(shell date +"%-m/%-d/%y") --author "\$(AUTHOR)" --year "\$(YEAR)" --organization "\$(ORG)"
endef

define scaffold_executable
	@echo "🚀 Generating executable: \$(1)"
	tuist scaffold executable --name \$(1) --date \$(shell date +"%-m/%-d/%y") --author "\$(AUTHOR)" --year "\$(YEAR)" --organization "\$(ORG)"
endef

.PHONY: micro_feature
micro_feature:
	@if [ -z "\$(name)" ]; then \\
		echo "❌ Please provide a feature name. Usage: make micro_feature name=FeatureName"; \\
		exit 1; \\
	fi
	\$(call scaffold_micro_feature,\$(name))
	@echo "✅ Successfully created microFeature: \$(name)"

.PHONY: framework
framework:
	@if [ -z "\$(name)" ]; then \\
		echo "❌ Please provide a framework name. Usage: make framework name=FrameworkName"; \\
		exit 1; \\
	fi
	\$(call scaffold_framework,\$(name))
	@echo "✅ Successfully created framework: \$(name)"

.PHONY: library
library:
	@if [ -z "\$(name)" ]; then \\
		echo "❌ Please provide a library name. Usage: make library name=LibraryName"; \\
		exit 1; \\
	fi
	\$(call scaffold_library,\$(name))
	@echo "✅ Successfully created library: \$(name)"

.PHONY: executable
executable:
	@if [ -z "\$(name)" ]; then \\
		echo "❌ Please provide an executable name. Usage: make executable name=ExecutableName"; \\
		exit 1; \\
	fi
	\$(call scaffold_executable,\$(name))
	@echo "✅ Successfully created executable: \$(name)"

.PHONY: app
app:
	@if [ -z "\$(name)" ]; then \\
		echo "❌ Please provide an app name. Usage: make app name=AppName"; \\
		exit 1; \\
	fi

	# 앱 디렉토리 생성
	@mkdir -p "\$(PROJECT_DIR)/\$(name)/Core"
	@mkdir -p "\$(PROJECT_DIR)/\$(name)/Features"
	@echo "📂 Created directories: Core & Features in \$(PROJECT_DIR)"

	# 첫 번째 앱 실행 파일 생성
	@make executable name=\$(name)
	@mv -f "\$(name)App" "\$(PROJECT_DIR)/\$(name)/"
	@echo "✅ Created and moved \$(name)App"

	# 기본 Core 모듈 생성 및 이동
	@make framework name=\$(name)Domain
	@mv -f "\$(name)Domain" "\$(PROJECT_DIR)/\$(name)/Core/"
	@echo "✅ Created and moved \$(name)Domain"

	@make framework name=\$(name)Common
	@mv -f "\$(name)Common" "\$(PROJECT_DIR)/\$(name)/Core/"
	@echo "✅ Created and moved \$(name)Common"

	@make framework name=\$(name)Data
	@mv -f "\$(name)Data" "\$(PROJECT_DIR)/\$(name)/Core/"
	@echo "✅ Created and moved \$(name)Data"

	# 기본 Feature 생성 및 이동
	@make micro_feature name=Default
	@mv -f "DefaultFeature" "\$(PROJECT_DIR)/\$(name)/Features/"
	@echo "✅ Created and moved SampleFeature"

	@echo "✅ All features and frameworks successfully created in \$(PROJECT_DIR)!"

.PHONY: generate
generate:
	@echo "🔄 Updating Tuist..."
	tuist clean
	tuist generate
	@echo "✅ Tuist updated!"

.PHONY: clean
clean:
	@echo "🧹 Cleaning project..."
	tuist clean
	rm -rf DerivedData
	rm -rf .build
	@echo "✅ Clean complete!"
EOF

echo "✅ Makefile created successfully in $PROJECT_DIR"
