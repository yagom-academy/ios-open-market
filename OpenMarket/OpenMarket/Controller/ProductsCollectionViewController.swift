import UIKit

class ProductsCollectionViewController: UICollectionViewController {
    private let loadingActivityIndicator = UIActivityIndicatorView()
    private var pageInformation: ProductsList?
    private var products = [Product]()
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
        loadProductsList(pageNumber: 1)
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
    
    private func loadProductsList(pageNumber: Int) {
        networkTask.requestProductList(pageNumber: pageNumber, itemsPerPage: 20) { result in
            switch result {
            case .success(let data):
                guard let productsList: ProductsList = try? self.jsonParser.decode(
                    from: data
                ) else { return }
                self.pageInformation = productsList
                self.products.append(contentsOf: productsList.pages)
                DispatchQueue.main.async {
                    self.loadingActivityIndicator.stopAnimating()
                    self.collectionView.reloadData()
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
    
    // MARK: - Collection view Data source
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return products.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let product = products[indexPath.item]
        let reuseIdentifier = ProductsCollectionViewCell.reuseIdentifier
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseIdentifier,
                for: indexPath
            ) as? ProductsCollectionViewCell,
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
    
    // MARK: - Collection view delegate
    
    override func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.item == products.count - 1,
           pageInformation?.hasNext == true,
           let num = pageInformation?.pageNumber {
            loadProductsList(pageNumber: num + 1)
        }
    }
}

extension ProductsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let frameWidth = collectionView.frameLayoutGuide.layoutFrame.width
        let frameHeight = collectionView.frameLayoutGuide.layoutFrame.height
        let shortLength = frameWidth < frameHeight ? frameWidth : frameHeight
        let cellWidth = shortLength / 2 - 15
        return CGSize(width: cellWidth, height: cellWidth * 1.5)
    }
}

extension ProductsCollectionViewController {
    static let gridViewStoryboardName = "ProductsCollectionView"
    static let gridViewControllerIdentifier = "GridViewController"
}
