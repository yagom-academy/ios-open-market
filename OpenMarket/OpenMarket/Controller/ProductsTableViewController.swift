import UIKit

class ProductsTableViewController: UITableViewController {
    private let loadingActivityIndicator = UIActivityIndicatorView()
    private var pageInformation: ProductsList?
    private var products = [Product]()
    private var jsonParser: JSONParser?
    private var networkTask: NetworkTask?
    
    convenience init?(coder: NSCoder, jsonParser: JSONParser, networkTask: NetworkTask) {
        self.init(coder: coder)
        self.jsonParser = jsonParser
        self.networkTask = networkTask
    }
    
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
        networkTask?.requestProductList(pageNumber: pageNumber, itemsPerPage: 20) { result in
            switch result {
            case .success(let data):
                guard let productsList: ProductsList = try? self.jsonParser?.decode(
                    from: data
                ) else { return }
                self.pageInformation = productsList
                self.products.append(contentsOf: productsList.pages)
                DispatchQueue.main.async {
                    self.loadingActivityIndicator.stopAnimating()
                    self.tableView.reloadData()
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
    
    private func setupCellImage(
        for cell: ProductsTableViewCell,
        from url: URL,
        indexPath: IndexPath,
        tableView: UITableView
    ) {
        cell.setup(imageView: nil)
        networkTask?.downloadImage(from: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    guard indexPath == tableView.indexPath(for: cell) else { return }
                    cell.setup(imageView: image)
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
        return products.count
    }
    
    override func tableView(
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
        setupCellImage(for: cell, from: url, indexPath: indexPath, tableView: tableView)
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == products.count - 1,
           pageInformation?.hasNext == true,
           let num = pageInformation?.pageNumber {
            loadProductsList(pageNumber: num + 1)
        }
    }
}

extension ProductsTableViewController {
    static let listViewStoryboardName = "ProductsTableView"
    static let listViewControllerIdentifier = "ListViewController"
}
