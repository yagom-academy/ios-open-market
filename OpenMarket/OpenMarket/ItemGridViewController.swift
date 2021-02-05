import UIKit

class ItemGridViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
}

extension ItemGridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemGridCollectionViewCell", for: indexPath)
        if let cell = cell as? ItemGridCollectionViewCell {
            
            
        }
        
        return cell
    }
    
    
}
