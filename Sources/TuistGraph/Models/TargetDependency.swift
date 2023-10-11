import Foundation
import TSCBasic

public enum SDKStatus: String, Codable {
    case required
    case optional
}

public enum TargetDependency: Equatable, Hashable, Codable {
    case target(name: String, platformFilters: PlatformFilters = [])
    case project(target: String, path: AbsolutePath, platformFilters: PlatformFilters = [])
    case framework(path: AbsolutePath, platformFilters: PlatformFilters = [])
    case xcframework(path: AbsolutePath, platformFilters: PlatformFilters = [])
    case library(path: AbsolutePath, publicHeaders: AbsolutePath, swiftModuleMap: AbsolutePath?, platformFilters: PlatformFilters = [])
    case package(product: String, platformFilters: PlatformFilters = [])
    case packagePlugin(product: String, platformFilters: PlatformFilters = [])
    case sdk(name: String, status: SDKStatus, platformFilters: PlatformFilters = [])
    case xctest
    
    public var platformFilters: PlatformFilters {
        switch self {
        case .target(name: _, platformFilters: let platformFilters):
            platformFilters
        case .project(target: _, path: _, platformFilters: let platformFilters):
            platformFilters
        case .framework(path: _, platformFilters: let platformFilters):
            platformFilters
        case .xcframework(path: _, platformFilters: let platformFilters):
            platformFilters
        case .library(path: _, publicHeaders: _, swiftModuleMap: _, platformFilters: let platformFilters):
            platformFilters
        case .package(product: _, platformFilters: let platformFilters):
            platformFilters
        case .packagePlugin(product: _, platformFilters: let platformFilters):
            platformFilters
        case .sdk(name: _, status: _, platformFilters: let platformFilters):
            platformFilters
        case .xctest: []
        }
    }
}
