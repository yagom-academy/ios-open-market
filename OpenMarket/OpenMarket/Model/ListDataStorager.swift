import Foundation

final class ListDataStorager: PageDataStorable {
    
    var storage: ProductListAsk.Response?
    var requester = ProductListAskRequester(pageNo: 1, itemsPerPage: 50)
    static let cachedImages = NSCache<NSString,NSData>()
    
    func appendMoreItem() {
        let appendItemAmount = 10
        let changeRequester = ProductListAskRequester(pageNo: 1, itemsPerPage: (requester.itemsPerPage + appendItemAmount))
        requester = changeRequester
    }

    func updateStorage(completion: @escaping () -> Void) {
        URLSession.shared.request(requester: requester) { (result) in
            switch result {
            case .success(let data):
                guard let data = self.requester.decode(data: data) else {
                    return
                }
                self.storage = data
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
