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
    private lazy var networkTask = NetworkTask(jsonParser: jsonParser)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProductsList()
    }
    
    private func loadProductsList() {
        networkTask.requestProductList(pageNumber: 1, itemsPerPage: 20) { result in
            switch result {
            case .success(let data):
                self.productsList = try? self.jsonParser.decode(from: data)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                let alert = UIAlertController(
                    title: "Network error",
                    message: "데이터를 불러오지 못했습니다.\n\(error.localizedDescription)",
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
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
        guard let product = productsList?.pages[indexPath.item] else {
            return ProductsCollectionViewCell()
        }
        guard let url = URL(string: product.thumbnail) else {
            return ProductsCollectionViewCell()
        }
        guard let imageData = try? Data(contentsOf: url) else {
            return ProductsCollectionViewCell()
        }
        let image = UIImage(data: imageData)
        cell.productImageView.image = image
        cell.productTitleLabel.text = product.name
        cell.productPriceLabel.text = product.price.description
        cell.productStockLabel.text = product.stock.description
        return cell
    }
}

extension ProductsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.frame.width / 2 - 10
        return CGSize(width: width, height: width)
    }
}
