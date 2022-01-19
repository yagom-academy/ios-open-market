import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    override init() { }
    var resumeDidCall = { }

    override func resume() {
        resumeDidCall()
    }
}
