import PackageDescription

let package = Package(
	name: "PlatformExtTest",
    dependencies: [
        .Package(url: "https://github.com/damienpontifex/SwiftOpenCL.git", majorVersion: 0)
    ]
)