import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    var taskCompletion: () -> ()
    
    init(taskCompletion: @escaping () -> () = {}) {
        self.taskCompletion = taskCompletion
    }
    
    override func resume() {
        taskCompletion()
    }
}
