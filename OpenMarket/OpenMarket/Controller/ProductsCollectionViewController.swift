import UIKit

class ProductsCollectionViewController: UICollectionViewController {
    private let loadingActivityIndicator = UIActivityIndicatorView()
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
        startActivityIndicator()
        loadProductsList()
    }
    
    private func startActivityIndicator() {
        view.addSubview(loadingActivityIndicator)
        
        loadingActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingActivityIndicator.centerYAnchor.constraint(
            equalTo: view.centerYAnchor
        ).isActive = true
        loadingActivityIndicator.centerXAnchor.constraint(
            equalTo: view.centerXAnchor
        ).isActive = true
        loadingActivityIndicator.startAnimating()
    }
    
    private func loadProductsList() {
        networkTask.requestProductList(pageNumber: 1, itemsPerPage: 20) { result in
            switch result {
            case .success(let data):
                self.productsList = try? self.jsonParser.decode(from: data)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.loadingActivityIndicator.stopAnimating()
                }
            case .failure(let error):
                self.showAlert(
                    title: "Network error",
                    message: "데이터를 불러오지 못했습니다.\n\(error.localizedDescription)"
                )
                self.loadingActivityIndicator.stopAnimating()
            }
        }
    }
    
    private func setupCellStyle(for cell: ProductsCollectionViewCell) {
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.systemGray.cgColor
        cell.layer.cornerRadius = 10
    }
    
    private func setupCellLabel(for cell: ProductsCollectionViewCell, from product: Product) {
        cell.productTitleLabel.attributedText = product.attributedTitle
        cell.productPriceLabel.attributedText = product.attributedPrice
        cell.productStockLabel.attributedText = product.attributedStock
    }
    
    private func setupCellImage(
        for cell: ProductsCollectionViewCell,
        from url: URL,
        indexPath: IndexPath,
        collectionView: UICollectionView
    ) {
        cell.productImageView.image = nil
        networkTask.downloadImage(from: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    guard indexPath == collectionView.indexPath(for: cell) else { return }
                    cell.productImageView.image = image
                }
            case .failure(let error):
                self.showAlert(
                    title: "Network error",
                    message: "데이터를 불러오지 못했습니다.\n\(error.localizedDescription)"
                )
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
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseIdentifier,
                for: indexPath
            ) as? ProductsCollectionViewCell,
            let product = productsList?.pages[indexPath.item],
            let url = URL(string: product.thumbnail) else {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: reuseIdentifier,
                    for: indexPath
                )
                return cell
            }
        setupCellStyle(for: cell)
        setupCellLabel(for: cell, from: product)
        setupCellImage(for: cell, from: url, indexPath: indexPath, collectionView: collectionView)
        return cell
    }
}

extension ProductsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.safeAreaLayoutGuide.layoutFrame.width / 2 - 15
        return CGSize(width: width, height: width * 1.5)
    }
}
