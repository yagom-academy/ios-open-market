import UIKit
import Foundation
import XCTest
@testable import OpenMarket

enum MockAPI {
    case test
    
    static let baseURL = "https://camp-open-market.herokuapp.com"
    
    var sampleItems: NSDataAsset {
        NSDataAsset.init(name: "items")!
    }
    var sampleItem: NSDataAsset {
        NSDataAsset.init(name: "item")!
    }
    var sampleID: NSDataAsset {
        NSDataAsset.init(name: "id")!
    }
    var listPageOnePath: String {
        "items/1"
    }
    var listPageOneURL: URL {
        URL(string: MockAPI.baseURL + listPageOnePath)!
    }
    var postProductPath: String {
        "item/"
    }
    var postProductURL: URL {
        URL(string: MockAPI.baseURL + postProductPath)!
    }
}
