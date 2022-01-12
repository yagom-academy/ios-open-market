import UIKit

class ViewController: UIViewController {
    
    let collectionView = ProductListView()
    
    override func loadView() {
        view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "ProductListCell", bundle: nil), forCellWithReuseIdentifier: ProductListCell.identifier)
    }
}
