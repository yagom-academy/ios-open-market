import UIKit

protocol ProductView {
    func indexPath(for cell: ProductCell) -> IndexPath?
    func reloadData()
}
