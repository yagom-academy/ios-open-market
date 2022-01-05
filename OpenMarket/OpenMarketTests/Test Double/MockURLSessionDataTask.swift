import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    var taskCompletion: () -> () = {}
    
    override func resume() {
        taskCompletion()
    }
}
