#!/bin/bash

# Stop script execution on error
set -e

# Base path where files will be generated
HELPERS_DIR=$1
ID=$2

if [ -z "$HELPERS_DIR" ]; then
    echo "❌ You must provide a directory path for file creation."
    exit 1
fi

if [ -z "$ID" ]; then
    echo "❌ You must provide a id for file creation."
    exit 1
fi

# Create the directory
mkdir -p "$HELPERS_DIR"

# Generate the Templates helper
echo "📄 Creating Project+Templates.swift file..."
cat <<EOF > "$HELPERS_DIR/Project+Templates.swift"
// Default Templates for Tuist
EOF

echo "✅ Project+Templates.swift file created successfully"
echo "$HELPERS_DIR/Project+Templates.swift"
echo ""

# Generate the DynamicFramework helper
echo "📄 Creating Project+DynamicFramework.swift file..."
cat <<EOF > "$HELPERS_DIR/Project+DynamicFramework.swift"
import ProjectDescription

extension Project {
    public static func dynamicFramework(
        name: String,
        settings: Settings? = nil,
        destinations: Destinations,
        targets: DeploymentTargets,
        dependencies: [TargetDependency],
        additionalTargets: [Target] = [],
        packages: [Package] = [],
        infoPlist: InfoPlist = .default,
        schemes: [Scheme] = []
    ) -> Project {
        let projectTargets: [Target] = [
            .target(
                name: name,
                destinations: destinations,
                product: .framework,
                bundleId: "${ID}.\(name)",
                deploymentTargets: targets,
                infoPlist: infoPlist,
                sources: ["Sources/**"],
                resources: ["Resources/**"],
                dependencies: dependencies
            ),
            .target(
                name: "\(name)Tests",
                destinations: destinations,
                product: .unitTests,
                bundleId: "${ID}.\(name)Tests",
                infoPlist: infoPlist,
                sources: ["Tests/**"],
                dependencies: [
                    .target(name: "\(name)")
                ]
            )
        ]
        return Project(
            name: name,
            packages: packages,
            settings: settings,
            targets: projectTargets + additionalTargets,
            schemes: schemes
        )
    }
}
EOF

echo "✅ Project+DynamicFramework.swift file created successfully"
echo "$HELPERS_DIR/Project+DynamicFramework.swift"
echo ""

# Generate the StaticLibrary helper
echo "📄 Creating Project+StaticLibrary.swift file..."
cat <<EOF > "$HELPERS_DIR/Project+StaticLibrary.swift"
import ProjectDescription

extension Project {
    public static func staticLibrary(
        name: String,
        settings: Settings? = nil,
        destinations: Destinations,
        targets: DeploymentTargets,
        dependencies: [TargetDependency],
        schemes: [Scheme] = []
    ) -> Project {
        return Project(
            name: name,
            settings: settings,
            targets: [
                .target(
                    name: name,
                    destinations: destinations,
                    product: .staticLibrary,
                    bundleId: "${ID}.\(name)",
                    deploymentTargets: targets,
                    infoPlist: .default,
                    sources: ["Sources/\(name)/**"],
                    dependencies: dependencies
                ),
                .target(
                    name: "\(name)Tests",
                    destinations: destinations,
                    product: .unitTests,
                    bundleId: "${ID}.\(name)Tests",
                    infoPlist: .default,
                    sources: ["Tests/**"],
                    dependencies: [
                        .target(name: "\(name)")
                    ]
                )
            ],
            schemes: schemes
        )
    }
}
EOF

echo "✅ Project+StaticLibrary.swift file created successfully"
echo "$HELPERS_DIR/Project+StaticLibrary.swift"
echo ""

# Generate the MicroFeature helper
echo "📄 Creating Project+MicroFeature.swift file..."
cat <<EOF > "$HELPERS_DIR/Project+MicroFeature.swift"
import ProjectDescription

extension Project {
    public static func microFeature(
        name: String,
        settings: Settings? = nil,
        destinations: Destinations,
        targets: DeploymentTargets,
        dependencies: [TargetDependency],
        infoPlist: [String: Plist.Value],
        schemes: [Scheme] = []
    ) -> Project {
        return Project(
            name: "\(name)",
            organizationName: "${ID}",
            settings: settings,
            targets: [
                .target(
                    name: "\(name)Sample",
                    destinations: destinations,
                    product: .app,
                    bundleId: "${ID}.\(name)Sample",
                    deploymentTargets: targets,
                    infoPlist: .extendingDefault(with: infoPlist),
                    sources: ["Sample/**"],
                    dependencies: [
                        .target(name: "\(name)"),
                        .target(name: "\(name)Testing")
                    ]
                ),
                .target(
                    name: "\(name)Tests",
                    destinations: destinations,
                    product: .unitTests,
                    bundleId: "${ID}.\(name)Tests",
                    deploymentTargets: targets,
                    infoPlist: .default,
                    sources: ["Tests/**"],
                    dependencies: [
                        .target(name: "\(name)"),
                        .target(name: "\(name)Testing")
                    ]
                ),
                .target(
                    name: "\(name)Testing",
                    destinations: destinations,
                    product: .framework,
                    bundleId: "${ID}.\(name)Testing",
                    deploymentTargets: targets,
                    infoPlist: .default,
                    sources: ["Testing/**"],
                    dependencies: [
                        .target(name: "\(name)Interface")
                    ]
                ),
                .target(
                    name: "\(name)",
                    destinations: destinations,
                    product: .framework,
                    bundleId: "${ID}.\(name)",
                    deploymentTargets: targets,
                    infoPlist: .default,
                    sources: ["Sources/**"],
                    dependencies: [
                        .target(name: "\(name)Interface")
                    ]
                ),
                .target(
                    name: "\(name)Interface",
                    destinations: destinations,
                    product: .framework,
                    bundleId: "${ID}.\(name)Interface",
                    deploymentTargets: targets,
                    infoPlist: .default,
                    sources: ["Interface/**"],
                    dependencies: dependencies
                )
            ],
            schemes: schemes
        )
    }
}
EOF

echo "✅ Project+MicroFeature.swift file created successfully"
echo "$HELPERS_DIR/Project+MicroFeature.swift"
echo ""

# Generate the Executable helper
echo "📄 Creating Project+Executable.swift file..."
cat <<EOF > "$HELPERS_DIR/Project+Executable.swift"
import ProjectDescription

extension Project {
    public static func executable(
        name: String,
        settings: Settings? = nil,
        destinations: Destinations,
        targets: DeploymentTargets,
        dependencies: [TargetDependency],
        infoPlist: [String: Plist.Value],
        schemes: [Scheme] = []
    ) -> Project {
        return Project(
            name: "\(name)App",
            organizationName: "${ID}",
            settings: settings,
            targets: [
                .target(
                    name: "\(name)App",
                    destinations: destinations,
                    product: .app,
                    bundleId: "${ID}.\(name)App",
                    deploymentTargets: targets,
                    infoPlist: .extendingDefault(with: infoPlist),
                    sources: ["Sources/**"],
                    resources: ["Resources/**"],
                    dependencies: dependencies
                ),
                .target(
                    name: "\(name)Tests",
                    destinations: destinations,
                    product: .unitTests,
                    bundleId: "${ID}.\(name)Tests",
                    deploymentTargets: targets,
                    infoPlist: .default,
                    sources: ["Tests/**"],
                    dependencies: [
                        .target(name: "\(name)App")
                    ]
                )
            ],
            schemes: schemes
        )
    }
}
EOF

echo "✅ Project+Executable.swift file created successfully"
echo "$HELPERS_DIR/Project+Executable.swift"
echo ""