import Foundation

enum NetworkingAPI {
    typealias HealthChecker = HealthCheckerManager
    typealias ProductRegistration = ProductRegistrationManager
    typealias ProductModify = ProductModifyManager
    typealias ProductDeleteSecretQuery = ProductDeleteSecretQueryManager
    typealias ProductDelete = ProductDeleteManager
    typealias ProductDetailQuery = ProductDetailQueryManager
    typealias ProductListQuery = ProductListQueryManager
}
