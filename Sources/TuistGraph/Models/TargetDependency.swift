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
    
    // TODO needs tests
    public func withFilters(_ platformFilters: PlatformFilters) -> TargetDependency {
        switch self {
        case .target(name: let name, platformFilters: _):
            return .target(name: name, platformFilters: platformFilters)
        case .project(target: let target, path: let path, platformFilters: _):
            return .project(target: target, path: path, platformFilters: platformFilters)
        case .framework(path: let path, platformFilters: _):
            return .framework(path: path, platformFilters: platformFilters)
        case .xcframework(path: let path, platformFilters: _):
            return .xcframework(path: path, platformFilters: platformFilters)
        case .library(path: let path, publicHeaders: let headers, swiftModuleMap: let moduleMap, platformFilters: _):
            return .library(path: path, publicHeaders: headers, swiftModuleMap: moduleMap, platformFilters: platformFilters)
        case .package(product: let product, platformFilters: _):
            return .package(product: product, platformFilters: platformFilters)
        case .packagePlugin(product: let product, platformFilters: _):
            return .packagePlugin(product: product, platformFilters: platformFilters)
        case .sdk(name: let name, status: let status, platformFilters: _):
            return .sdk(name: name, status: status, platformFilters: platformFilters)
        case .xctest: return .xctest
        }
    }
}
