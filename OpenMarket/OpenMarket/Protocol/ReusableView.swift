import UIKit

protocol ReusableView: NSObject {
    static var identifier: String { get }
}

extension ReusableView where Self: UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension ReusableView where Self: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension ReusableView where Self: UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}
extension UICollectionViewCell: ReusableView {}
extension UIViewController: ReusableView {}
