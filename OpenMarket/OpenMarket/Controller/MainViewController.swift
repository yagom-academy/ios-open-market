import UIKit

class MainViewController: UIViewController {
    private let loadingActivityIndicator = UIActivityIndicatorView()
    private var pageInformation: ProductsList?
    private var products = [Product]()
    private var items = [ProductCellItem]()
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
    private lazy var productsDataSource = ProductsDataSource(networkTask: networkTask)
    private var tableViewDataSource: UITableViewDiffableDataSource<Section, ProductCellItem>?
    
    
    @IBOutlet private weak var viewSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        changeSubview()
        startActivityIndicator()
        loadProductsList(pageNumber: 1)
    }
    
    private func loadProductsList(pageNumber: Int) {
        networkTask.requestProductList(pageNumber: pageNumber, itemsPerPage: 20) { result in
            switch result {
            case .success(let data):
                guard let productsList: ProductsList = try? self.jsonParser.decode(
                    from: data
                ) else { return }
                self.pageInformation = productsList
                self.productsDataSource.append(contentsOf: productsList.pages)
                productsList.pages.forEach { product in
                    let item = ProductCellItem(
                        title: product.attributedTitle,
                        price: product.attributedPrice,
                        stock: product.attributedStock,
                        thumbnail: product.thumbnail
                    )
                    self.items.append(item)
                }
                DispatchQueue.main.async {
                    self.loadingActivityIndicator.stopAnimating()
//                    let view = self.view as? ProductView
//                    view?.reloadData()
                    var snapshot = NSDiffableDataSourceSnapshot<Section, ProductCellItem>()
                    snapshot.appendSections([.main])
                    snapshot.appendItems(self.items, toSection: .main)
                    self.tableViewDataSource?.apply(snapshot)
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
    
    private func loadNextPage(ifLastItemAt indexPath: IndexPath) {
        if productsDataSource.isLastIndex(at: indexPath.item),
           pageInformation?.hasNext == true,
           let num = pageInformation?.pageNumber {
            loadProductsList(pageNumber: num + 1)
        }
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
    
    private func setupSegmentedControl() {
        viewSegmentedControl.selectedSegmentTintColor = .systemBlue
        viewSegmentedControl.layer.borderColor = UIColor.systemBlue.cgColor
        viewSegmentedControl.layer.borderWidth = 1.0
        viewSegmentedControl.setTitleTextAttributes(
            [.foregroundColor: UIColor.white],
            for: .selected
        )
        viewSegmentedControl.setTitleTextAttributes(
            [.foregroundColor: UIColor.systemBlue],
            for: .normal
        )
    }
    
    private func changeSubview() {
        guard let selectedSegment = Segement(
            rawValue: viewSegmentedControl.selectedSegmentIndex
        ) else { return }
        self.view = loadView(from: selectedSegment)
    }
    
    @IBAction private func segmentedControlChanged(_ sender: UISegmentedControl) {
        changeSubview()
    }
}

extension MainViewController {
    enum Section {
        case main
    }
    
    private enum Segement: Int {
        case list
        case grid
    }
    
    private func setupItemImage(url: URL, item: ProductCellItem) {
        item.image = nil
        networkTask.downloadImage(from: url) { result in
            let image: UIImage?
            switch result {
            case .success(let data):
                image = UIImage(data: data)
                item.image = image
            case .failure:
                image = UIImage(systemName: "xmark.app")
                item.image = image
            }
            guard var updatedSnapshot = self.tableViewDataSource?.snapshot() else { return }
            updatedSnapshot.reloadItems([item])
            self.tableViewDataSource?.apply(updatedSnapshot)
        }
    }
    
    private func loadView(from segment: Segement) -> UIView {
        switch segment {
        case .list:
            let nibName = UINib(nibName: "ProductsTableViewCell", bundle: nil)
            let tableView = UITableView()
            tableView.dataSource = productsDataSource
            tableView.delegate = self
            tableView.register(
                nibName,
                forCellReuseIdentifier: ProductsTableViewCell.reuseIdentifier
            )
            tableViewDataSource = UITableViewDiffableDataSource<Section, ProductCellItem>(
                tableView: tableView
            ) { (tableView, indexPath, item) -> UITableViewCell? in
                let reuseIdentifier = ProductsTableViewCell.reuseIdentifier
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: reuseIdentifier,
                    for: indexPath
                )
                guard let cell = cell as? ProductsTableViewCell,
                      let url = URL(string: item.thumbnail) else {
                          return cell
                      }
                cell.setup(titleLabel: item.title, priceLabel: item.price, stockLabel: item.stock)
                self.setupItemImage(url: url, item: item)
                return cell
            }
            var snapshot = NSDiffableDataSourceSnapshot<Section, ProductCellItem>()
            snapshot.appendSections([.main])
            snapshot.appendItems(items, toSection: .main)
            tableViewDataSource?.apply(snapshot)
            return tableView
        case .grid:
            let nibName = UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
            layout.sectionInsetReference = .fromSafeArea
            
            let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
            collectionView.dataSource = productsDataSource
            collectionView.delegate = self
            collectionView.register(
                nibName,
                forCellWithReuseIdentifier: ProductsCollectionViewCell.reuseIdentifier
            )
            return collectionView
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        loadNextPage(ifLastItemAt: indexPath)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        loadNextPage(ifLastItemAt: indexPath)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
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
