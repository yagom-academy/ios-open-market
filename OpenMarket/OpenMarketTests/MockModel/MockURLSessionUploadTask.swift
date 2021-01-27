
import Foundation
import XCTest
@testable import OpenMarket

class MockURLSessionUploadTask: URLSessionUploadTask {
    override init() { }
    var resumeDidCall: () -> Void = {}
    
    override func resume() {
        resumeDidCall()
    }
}
