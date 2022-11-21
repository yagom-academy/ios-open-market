//  Created by Aejong, Tottale on 2022/11/17.

import Foundation

final class MockURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: () -> Void = {}

    override func resume() {
        resumeDidCall()
    }
}
