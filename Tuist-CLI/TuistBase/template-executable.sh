set -e

TEMPLATES_DIR=$1
minimumVersion=$2

if [ -z "$TEMPLATES_DIR" ]; then
    echo "❌ You must provide a directory path for file creation."
    exit 1
fi

if [ -z "$minimumVersion" ]; then
    echo "❌ You must provide a minimumVersion."
    exit 1
fi

mkdir -p "${TEMPLATES_DIR}/executable"

# Generate the Executable template
echo "📄 Creating executable.swift file..."

cat <<EOF > "${TEMPLATES_DIR}/executable/executable.swift"
import ProjectDescription

fileprivate let nameAttribute: Template.Attribute = .required("name")
fileprivate let dateAttrribute: Template.Attribute = .required("date")
fileprivate let author: Template.Attribute = .required("author")
fileprivate let year: Template.Attribute = .required("year")
fileprivate let organization: Template.Attribute = .required("organization")

fileprivate let template = Template(
    description: "Micro Architecture Feature",
    attributes: [
        nameAttribute,
        dateAttrribute,
        author,
        year,
        organization
    ],
    items: [
        .file(
            path: "\(nameAttribute)App/Project.swift",
            templatePath: "Project.stencil"
        ),
        .file(
            path: "\(nameAttribute)App/Sources/\(nameAttribute)App.swift",
            templatePath: "App.stencil"
        ),
        .file(
            path: "\(nameAttribute)App/Sources/AppDelegate.swift",
            templatePath: "AppDelegate.stencil"
        ),
        .file(
            path: "\(nameAttribute)App/Tests/\(nameAttribute)Tests.swift",
            templatePath: "Tests.stencil"
        ),
        .file(
            path: "\(nameAttribute)App/Resources/ResourceSample.json",
            templatePath: "Resources.stencil"
        )
    ]
)
EOF

# Generate the Executable template
echo "📄 Creating Project.stencil file..."

cat <<EOF > "${TEMPLATES_DIR}/executable/Project.stencil"
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.executable(
    name: "{{ name }}",
    settings: .settings(configurations: [
        .debug(name: .debug),
        .debug(name: "Stage"),
        .release(name: .release)
    ]),
    destinations: .iOS,
    targets: .iOS("${minimumVersion}"),
    dependencies: [],
    infoPlist: [
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
        "UIMainStoryboardFile": "",
        "UILaunchStoryboardName": "LaunchScreen",
        "NSAppTransportSecurity": [
            "NSAllowsArbitraryLoads": true
        ]
    ],
    schemes: [
        .scheme(
            name: "{{ name }}App-Debug",
            shared: true,
            buildAction: .buildAction(targets: ["{{ name }}App"]),
            runAction: .runAction(configuration: .debug)
        ),
        .scheme(
            name: "{{ name }}App-Stage",
            shared: true,
            buildAction: .buildAction(targets: ["{{ name }}App"]),
            runAction: .runAction(configuration: "Stage")
        ),
        .scheme(
            name: "{{ name }}App-Release",
            shared: true,
            buildAction: .buildAction(targets: ["{{ name }}App"]),
            runAction: .runAction(configuration: .release)
        )
    ]
)
EOF

# Generate the App stencil
echo "📄 Creating App.stencil file..."

cat <<EOF > "${TEMPLATES_DIR}/executable/App.stencil"
//
//  {{ name }}App.swift
//  {{ name }}App
//
//  Created by {{ author }} on {{ date }}.
//  Copyright © {{ year }} {{ organization }} All rights reserved.
//

import SwiftUI

@main
struct {{ name }}App: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, World! this is {{ name }} Sample App!")
            .padding()
    }
}
EOF

# Generate the AppDelegate stencil
echo "📄 Creating AppDelegate.stencil file..."

cat <<EOF > "${TEMPLATES_DIR}/executable/AppDelegate.stencil"
//
//  AppDelegate.swift
//  {{ name }}App
//
//  Created by {{ author }} on {{ date }}.
//  Copyright © {{ year }} {{ organization }} All rights reserved.
//

import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate, ObservableObject {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        return true
    }
}
EOF

# Generate the Testing stencil
echo "📄 Creating Tests.stencil file..."

cat <<EOF > "${TEMPLATES_DIR}/executable/Tests.stencil"
//
//  {{ name }}Tests.swift
//  {{ name }}App
//
//  Created by {{ author }} on {{ date }}.
//  Copyright © {{ year }} {{ organization }} All rights reserved.
//

import XCTest
@testable import {{ name }}

final class {{ name }}Tests: XCTestCase {
    func testExample() throws {
        XCTAssertEqual(true, true)
    }
}

EOF

# Generate the Resources stencil
echo "📄 Creating Resources.stencil file..."

cat <<EOF > "${TEMPLATES_DIR}/executable/Resources.stencil"
{
    "exampleKey": "exampleValue"
}
EOF

echo "✅ MicroFeature templates created successfully"
echo ""