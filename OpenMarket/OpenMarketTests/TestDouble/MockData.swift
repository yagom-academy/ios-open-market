import UIKit

struct MockData {
    var healthData: Data {
        let health = "\"OK\""
        return health.data(using: .utf8)!
    }
    
    var productListData: Data {
        return NSDataAsset(name: "products")!.data
    }
}
