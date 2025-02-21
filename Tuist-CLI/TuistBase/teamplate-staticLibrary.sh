#!/bin/bash

# Stop script execution on error
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

mkdir -p "${TEMPLATES_DIR}/staticLibrary"

# Generate the DynamicFramwork template
echo "📄 Creating staticLibrary.swift file..."

cat <<EOF > "${TEMPLATES_DIR}/staticLibrary/staticLibrary.swift"
import ProjectDescription

fileprivate let nameAttribute: Template.Attribute = .required("name")
fileprivate let dateAttrribute: Template.Attribute = .required("date")
fileprivate let author: Template.Attribute = .required("author")
fileprivate let year: Template.Attribute = .required("year")
fileprivate let organization: Template.Attribute = .required("organization")

fileprivate let template = Template(
    description: "Static Library Template",
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
            path: "\(nameAttribute)/Sources/\(nameAttribute)/\(nameAttribute).swift",
            templatePath: "Sources.stencil"
        ),
        .file(
            path: "\(nameAttribute)/Tests/\(nameAttribute)Tests.swift",
            templatePath: "Tests.stencil"
        ),
    ]
)
EOF

# Generate the Project stencil
echo "📄 Creating Project.stencil file..."

cat <<EOF > "${TEMPLATES_DIR}/staticLibrary/Project.stencil"
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticLibrary(
    name: "{{ name }}",
    settings: .settings(configurations: [
        .debug(name: .debug),
        .debug(name: "Stage"),
        .release(name: .release)
    ]),
    destinations: .iOS,
    targets: .iOS("${minimumVersion}"),
    dependencies: [],
    schemes: [
        .scheme(
            name: "{{ name }}",
            shared: true,
            buildAction: .buildAction(targets: ["{{ name }}"]),
            runAction: .runAction(configuration: .debug)
        )
    ]
)
EOF

# Generate the Sources stencil
echo "📄 Creating Srouces.stencil file..."

cat <<EOF > "${TEMPLATES_DIR}/staticLibrary/Sources.stencil"
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
    
    public func hello() {
        print("Hello, World! this is {{ name }}!")
    }
}
EOF

# Generate the Tests stencil
echo "📄 Creating Tests.stencil file..."

cat <<EOF > "${TEMPLATES_DIR}/staticLibrary/Tests.stencil"
//
//  {{ name }}.swift
//  {{ name }}
//
//  Created by {{ author }} on {{ date }}.
//  Copyright © {{ year }} {{ organization }} All rights reserved.
//

import Foundation
import XCTest
@testable import {{ name }}

final class {{ name }}Tests: XCTestCase {
    func testExample() {
        XCTAssertEqual(true, true)
    }
}
EOF

echo "✅ StaticLibrary templates created successfully"
echo ""