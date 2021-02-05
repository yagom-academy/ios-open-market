import UIKit

class ItemGridViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
}

extension ItemGridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ItemListModel.shared.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemGridCollectionViewCell", for: indexPath)
        if let cell = cell as? ItemGridCollectionViewCell {
            let model = ItemListModel.shared.data[indexPath.row]
            cell.setModel(ItemViewModel(model))
        }
        
        return cell
    }
    
    
}
