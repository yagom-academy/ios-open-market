import UIKit

class ProductsCollectionViewController: UICollectionViewController {
    private let reuseIdentifier = "productCell"
    private var productsList: ProductsList?
    private let jsonParser: JSONParser = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        let jsonParser = JSONParser(
            dateDecodingStrategy: .formatted(formatter),
            keyDecodingStrategy: .convertFromSnakeCase,
            keyEncodingStrategy: .convertToSnakeCase
        )
        return jsonParser
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = NSDataAsset(name: "products")!.data
        productsList = try? jsonParser.decode(from: data)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return productsList?.pages.count ?? 0
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier, for: indexPath
        ) as? ProductsCollectionViewCell else {
            return ProductsCollectionViewCell()
        }
        guard let url = URL(string: productsList?.pages[indexPath.item].thumbnail ?? "") else {
            return ProductsCollectionViewCell()
        }
        guard let imageData = try? Data(contentsOf: url) else {
            return ProductsCollectionViewCell()
        }
        let image = UIImage(data: imageData)
        cell.productImageView.image = image
        return cell
    }
}
