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

mkdir -p "${TEMPLATES_DIR}/microFeature"

# Generate the MicroFeature template
echo "📄 Creating microFeature.swift file..."

cat <<EOF > "${TEMPLATES_DIR}/microFeature/microFeature.swift"
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
            path: "\(nameAttribute)/Project.swift",
            templatePath: "Project.stencil"
        ),
        .file(
            path: "\(nameAttribute)/Sample/\(nameAttribute)Sample.swift",
            templatePath: "App.stencil"
        ),
        .file(
            path: "\(nameAttribute)/Sample/AppDelegate.swift",
            templatePath: "AppDelegate.stencil"
        ),
        .file(
            path: "\(nameAttribute)/Tests/\(nameAttribute)Tests.swift",
            templatePath: "Tests.stencil"
        ),
        .file(
            path: "\(nameAttribute)/Testing/\(nameAttribute)Testing.swift",
            templatePath: "Testing.stencil"
        ),
        .file(
            path: "\(nameAttribute)/Sources/\(nameAttribute).swift",
            templatePath: "Sources.stencil"
        ),
        .file(
            path: "\(nameAttribute)/Interface/\(nameAttribute)Interface.swift",
            templatePath: "Interface.stencil"
        ),
        .file(
            path: "\(nameAttribute)/Resources/ResourceSample.json",
            templatePath: "Resources.stencil"
        )
    ]
)
EOF

# Generate the MicroFeature template
echo "📄 Creating Project.stencil file..."

cat <<EOF > "${TEMPLATES_DIR}/microFeature/Project.stencil"
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.microFeature(
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
            name: "{{ name }}Sample",
            shared: true,
            buildAction: .buildAction(targets: ["{{ name }}Sample"]),
            runAction: .runAction(configuration: .debug)
        ),
        .scheme(
            name: "{{ name }}",
            shared: true,
            buildAction: .buildAction(targets: ["{{ name }}"]),
            runAction: .runAction(configuration: .debug)
        )
    ]
)
EOF

# Generate the App stencil
echo "📄 Creating App.stencil file..."

cat <<EOF > "${TEMPLATES_DIR}/microFeature/App.stencil"
//
//  {{ name }}Sample.swift
//  {{ name }}
//
//  Created by {{ author }} on {{ date }}.
//  Copyright © {{ year }} {{ organization }} All rights reserved.
//

import SwiftUI

@main
struct {{ name }}Sample: App {
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

cat <<EOF > "${TEMPLATES_DIR}/microFeature/AppDelegate.stencil"
//
//  AppDelegate.swift
//  {{ name }}
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

# Generate the Interface stencil
echo "📄 Creating Interface.stencil file..."

cat <<EOF > "${TEMPLATES_DIR}/microFeature/Interface.stencil"
//
//  {{ name }}Interface.swift
//  {{ name }}
//
//  Created by {{ author }} on {{ date }}.
//  Copyright © {{ year }} {{ organization }} All rights reserved.
//

import Foundation

public protocol {{ name }}Interface { }
EOF

# Generate the Sources stencil
echo "📄 Creating Sources.stencil file..."

cat <<EOF > "${TEMPLATES_DIR}/microFeature/Sources.stencil"
//
//  {{ name }}.swift
//  {{ name }}
//
//  Created by {{ author }} on {{ date }}.
//  Copyright © {{ year }} {{ organization }} All rights reserved.
//

import Foundation

public final class {{ name }} {

    public init() { }
}
EOF

# Generate the Testing stencil
echo "📄 Creating Testing.stencil file..."

cat <<EOF > "${TEMPLATES_DIR}/microFeature/Testing.stencil"
//
//  {{ name }}Testing.swift
//  {{ name }}
//
//  Created by {{ author }} on {{ date }}.
//  Copyright © {{ year }} {{ organization }} All rights reserved.
//

import Foundation

public final class {{ name }}Testing {

    public init() { }

    public func someMock() -> [String] {
        return []
    }
}
EOF

# Generate the Testing stencil
echo "📄 Creating Tests.stencil file..."

cat <<EOF > "${TEMPLATES_DIR}/microFeature/Tests.stencil"
//
//  {{ name }}Tests.swift
//  {{ name }}
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

cat <<EOF > "${TEMPLATES_DIR}/microFeature/Resources.stencil"
{
    "exampleKey": "exampleValue"
}
EOF

echo "✅ MicroFeature templates created successfully"
echo ""

