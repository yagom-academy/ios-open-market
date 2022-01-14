import UIKit

extension UICollectionView: ProductView {
    func indexPath(for cell: ProductCell) -> IndexPath? {
        guard let collectionViewCell = cell as? UICollectionViewCell else {
            return nil
        }
        return indexPath(for: collectionViewCell)
    }
}
