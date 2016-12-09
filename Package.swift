import PackageDescription

let package = Package(
    name: "leds",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/uraimo/SwiftyGPIO.git", majorVersion: 0)
		, .Package(url: "https://github.com/ReactiveX/RxSwift.git", majorVersion: 3)
//		, .Package(url: "https://github.com/Zewo/Venice.git", majorVersion: 0, minor: 14)
    ]
)
