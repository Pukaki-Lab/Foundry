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

mkdir -p "${TEMPLATES_DIR}/cleanFeature"

# Generate the CleanFeature template
echo "📄 Creating CleanFeature.swift file..."

cat <<EOF > "${TEMPLATES_DIR}/cleanFeature/cleanFeature.swift"
import ProjectDescription

fileprivate let nameAttribute: Template.Attribute = .required("name")
fileprivate let dateAttrribute: Template.Attribute = .required("date")
fileprivate let author: Template.Attribute = .required("author")
fileprivate let year: Template.Attribute = .required("year")
fileprivate let organization: Template.Attribute = .required("organization")

fileprivate let template = Template(
    description: "Clean Architecture Feature",
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
            path: "\(nameAttribute)/Presentation/\(nameAttribute)View.swift",
            templatePath: "Presentation.stencil"
        ),
        .file(
            path: "\(nameAttribute)/Domain/\(nameAttribute)Domain.swift",
            templatePath: "Domain.stencil"
        ),
        .file(
            path: "\(nameAttribute)/Data/\(nameAttribute)Data.swift",
            templatePath: "Data.stencil"
        ),
        .file(
            path: "\(nameAttribute)/Tests/\(nameAttribute)Tests.swift",
            templatePath: "Tests.stencil"
        ),
        .file(
            path: "\(nameAttribute)/Resources/ResourceSample.json",
            templatePath: "Resources.stencil"
        )
    ]
)
EOF

# Generate the CleanFeature template
echo "📄 Creating Project.stencil file..."

cat <<EOF > "${TEMPLATES_DIR}/cleanFeature/Project.stencil"
import ProjectDescription
import ProjectDescriptionHelpers

fileprivate let project = Project.cleanFeature(
    name: "{{ name }}",
    settings: .settings(
        configurations: [
            .debug(name: .debug),
            .debug(name: "Stage"),
            .release(name: .release)
        ]
    ),
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
            name: "{{ name }}Presentation",
            shared: true,
            buildAction: .buildAction(targets: ["{{ name }}Presentation"]),
            runAction: .runAction(configuration: .debug)
        ),
        .scheme(
            name: "{{ name }}Data",
            shared: true,
            buildAction: .buildAction(targets: ["{{ name }}Data"]),
            runAction: .runAction(configuration: .debug)
        ),
        .scheme(
            name: "{{ name }}Domain",
            shared: true,
            buildAction: .buildAction(targets: ["{{ name }}Domain"]),
            runAction: .runAction(configuration: .debug)
        )
    ]
)
EOF

# Generate the App stencil
echo "📄 Creating App.stencil file..."

cat <<EOF > "${TEMPLATES_DIR}/cleanFeature/App.stencil"
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

cat <<EOF > "${TEMPLATES_DIR}/cleanFeature/AppDelegate.stencil"
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

# Generate the Domain stencil
echo "📄 Creating Domain.stencil file..."

cat <<EOF > "${TEMPLATES_DIR}/cleanFeature/Domain.stencil"
//
//  {{ name }}Domain.swift
//  {{ name }}
//
//  Created by {{ author }} on {{ date }}.
//  Copyright © {{ year }} {{ organization }} All rights reserved.
//

import Foundation

public final class {{ name }}Domain {

}
EOF

# Generate the Data stencil
echo "📄 Creating Data.stencil file..."

cat <<EOF > "${TEMPLATES_DIR}/cleanFeature/Data.stencil"
//
//  {{ name }}Data.swift
//  {{ name }}
//
//  Created by {{ author }} on {{ date }}.
//  Copyright © {{ year }} {{ organization }} All rights reserved.
//

import Foundation

public final class {{ name }}Data {

    public init() { }
}
EOF

# Generate the Presentation stencil
echo "📄 Creating Presentation.stencil file..."

cat <<EOF > "${TEMPLATES_DIR}/cleanFeature/Presentation.stencil"
//
//  {{ name }}View.swift
//  {{ name }}
//
//  Created by {{ author }} on {{ date }}.
//  Copyright © {{ year }} {{ organization }} All rights reserved.
//

import SwiftUI

public final class {{ name }}View: View {

    public init() { }

    public var body: some View {
        Text("Hello, World! this is {{ name }} View!")
            .padding()
    }
}
EOF

# Generate the Tests stencil
echo "📄 Creating Tests.stencil file..."

cat <<EOF > "${TEMPLATES_DIR}/cleanFeature/Tests.stencil"
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

cat <<EOF > "${TEMPLATES_DIR}/cleanFeature/Resources.stencil"
{
    "exampleKey": "exampleValue"
}
EOF

echo "✅ CleanFeature templates created successfully"
echo ""

