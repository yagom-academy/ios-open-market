import Foundation

protocol ProductsDataSourceDelegate: NSObject {
    func stopActivityIndicator()
    func showAlert(title: String?, message: String?)
    func reloadData()
}
