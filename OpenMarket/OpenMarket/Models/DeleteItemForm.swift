import Foundation

struct DeleteItemForm {
    var id: String?
    var password: String?
    
    var convertParameter: [String: Any]? {
        guard let id = id else {
            return nil
        }
        guard let password = password else {
            return nil
        }
        
        var parameter = [String: Any]()
        parameter["id"] = id
        parameter["password"] = password
        
        return parameter
    }
}
