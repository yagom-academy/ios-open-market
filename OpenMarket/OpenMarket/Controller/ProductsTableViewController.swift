import UIKit

class ProductsTableViewController: UITableViewController {
    private let loadingActivityIndicator = UIActivityIndicatorView()
    private let reuseIdentifier = "productsListCell"
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
                    self.tableView.reloadData()
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
    
    private func setupCellLabel(for cell: ProductsTableViewCell, from product: Product) {
        cell.titleLabel.attributedText = product.attributedTitle
        cell.priceLabel.attributedText = product.attributedPrice
        cell.stockLabel.attributedText = product.attributedStock
    }
    
    private func setupCellImage(
        for cell: ProductsTableViewCell,
        from url: URL,
        indexPath: IndexPath,
        tableView: UITableView
    ) {
        cell.productImageView.image = nil
        networkTask.downloadImage(from: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    guard indexPath == tableView.indexPath(for: cell) else { return }
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsList?.pages.count ?? 0
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath
        ) as? ProductsTableViewCell,
              let product = productsList?.pages[indexPath.row],
              let url = URL(string: product.thumbnail) else {
                  let cell = tableView.dequeueReusableCell(
                    withIdentifier: reuseIdentifier,
                    for: indexPath
                  )
                  return cell
              }
        setupCellLabel(for: cell, from: product)
        setupCellImage(for: cell, from: url, indexPath: indexPath, tableView: tableView)
        return cell
    }
}
