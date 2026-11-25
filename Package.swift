// swift-tools-version: 5.9
import PackageDescription

// prod 배포 레포용 manifest — 메인 SDK 파이프라인이 GitHub Release 에 NestAdsSDK.xcframework.zip 을 올리고
// scripts/write-package-manifest.sh 가 버전 · checksum · 채널별 KMP 레포를 채워 넣는다. 손으로 고치지 않는다.
//
// binaryTarget 은 의존성을 가질 수 없어 빈 래퍼 target 이 메인 SDK 바이너리와 v3(KMP) 엔진을 함께 묶는다.
// 매체사는 지금처럼 product "NestAdsSDK" 를 추가하고 `import NestAdsSDK` 만 쓴다.
let package = Package(
  name: "NestAdsSDK",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "NestAdsSDK",
      targets: ["NestAdsSDKWrapper"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/wisebirds/nestads-ios-sdk-kmp-axz", exact: "3.0.1"),
  ],
  targets: [
    .binaryTarget(
      name: "NestAdsSDK",
      url: "https://github.com/wisebirds/nestads-ios-sdk-axz/releases/download/2.21.0/NestAdsSDK.xcframework.zip",
      checksum: "568474d1e548801330defc15d4391b62ba06c34b4f825f884de5c9c61a80183d"
    ),
    .target(
      name: "NestAdsSDKWrapper",
      dependencies: [
        "NestAdsSDK",
        .product(name: "NestAdsSDK_KMP", package: "nestads-ios-sdk-kmp-axz"),
      ],
      path: "Sources/Wrapper"
    ),
  ]
)
