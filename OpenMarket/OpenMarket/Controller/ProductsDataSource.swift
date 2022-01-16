import UIKit

class ProductsDataSource: NSObject {
    weak var delegate: ProductsDataSourceDelegate?
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
    
    func loadProductsList(pageNumber: Int) {
        networkTask.requestProductList(pageNumber: pageNumber, itemsPerPage: 20) { result in
            switch result {
            case .success(let data):
                guard let productsList: ProductsList = try? self.jsonParser.decode(
                    from: data
                ) else { return }
                self.pageInformation = productsList
                self.products.append(contentsOf: productsList.pages)
                DispatchQueue.main.async {
                    self.delegate?.stopActivityIndicator()
                    self.delegate?.reloadData()
                }
            case .failure(let error):
                self.delegate?.showAlert(
                    title: "Network error",
                    message: "데이터를 불러오지 못했습니다.\n\(error.localizedDescription)"
                )
                self.delegate?.stopActivityIndicator()
            }
        }
    }
    
    func loadNextPage(ifLastItemAt indexPath: IndexPath) {
        if indexPath.item == products.count - 1,
           pageInformation?.hasNext == true,
           let num = pageInformation?.pageNumber {
            loadProductsList(pageNumber: num + 1)
        }
    }
    
    private func setupCellImage(
        for cell: ProductCell,
        from url: URL,
        indexPath: IndexPath,
        productView: ProductView
    ) {
        cell.setup(imageView: nil)
        networkTask.downloadImage(from: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    guard indexPath == productView.indexPath(for: cell) else { return }
                    cell.setup(imageView: image)
                }
            case .failure(let error):
                self.delegate?.showAlert(
                    title: "Network error",
                    message: "데이터를 불러오지 못했습니다.\n\(error.localizedDescription)"
                )
            }
        }
    }
}

extension ProductsDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let product = products[indexPath.row]
        let reuseIdentifier = ProductsTableViewCell.reuseIdentifier
        let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath
        )
        guard let cell = cell as? ProductsTableViewCell,
              let url = URL(string: product.thumbnail) else {
                  return cell
              }
        cell.setup(
            titleLabel: product.attributedTitle,
            priceLabel: product.attributedPrice,
            stockLabel: product.attributedStock
        )
        setupCellImage(for: cell, from: url, indexPath: indexPath, productView: tableView)
        return cell
    }
}

extension ProductsDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return products.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let product = products[indexPath.item]
        let reuseIdentifier = ProductsCollectionViewCell.reuseIdentifier
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        )
        guard let cell = cell as? ProductsCollectionViewCell,
              let url = URL(string: product.thumbnail) else {
                  return cell
              }
        cell.setup(
            titleLabel: product.attributedTitle,
            priceLabel: product.attributedPrice,
            stockLabel: product.attributedStock
        )
        setupCellImage(for: cell, from: url, indexPath: indexPath, productView: collectionView)
        return cell
    }
}
