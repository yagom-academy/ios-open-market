
import Foundation

class PasswordContainer {
    static let shared = PasswordContainer()
    private var passwordContainer = [Int : String]()
    
    private init() {}
    
    func addPassword(key: Int, password: String) {
        guard passwordContainer[key] == nil else {
            preconditionFailure()
            //에러 안내문 alert
        }
        passwordContainer[key] = password
    }
    
    func changePassword(key: Int, password: String) {
        guard passwordContainer[key] != nil else {
            preconditionFailure()
            //에러 안내문 alert

        }
        passwordContainer[key] = password
    }
    
    func isPasswordRight(key: Int, password: String) -> Bool {
        (passwordContainer[key] == password) ? true : false
    }
    
}
