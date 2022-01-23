import Foundation

protocol PageDataStorable {
    
    var storage: ProductListAsk.Response? { get set }
    func updateStorage(completion: @escaping () -> Void)
    func appendMoreItem() 
}
