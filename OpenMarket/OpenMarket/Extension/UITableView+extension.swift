import UIKit

extension UITableView: ProductView {
    func indexPath(for cell: ProductCell) -> IndexPath? {
        guard let tableViewCell = cell as? UITableViewCell else {
            return nil
        }
        return indexPath(for: tableViewCell)
    }
}
