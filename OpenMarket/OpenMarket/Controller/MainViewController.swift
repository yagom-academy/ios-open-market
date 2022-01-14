import UIKit

class MainViewController: UIViewController {
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
                self.products.append(contentsOf: productsList.pages)
                DispatchQueue.main.async {
                    self.loadingActivityIndicator.stopAnimating()
                    let productView = self.view as? ProductView
                    productView?.reloadData()
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
    private enum Segement: Int {
        case list
        case grid
    }
    
    private func loadView(from segment: Segement) -> UIView {
        switch segment {
        case .list:
            let nibName = UINib(nibName: "ProductsTableViewCell", bundle: nil)
            let tableView = UITableView()
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(
                nibName,
                forCellReuseIdentifier: ProductsTableViewCell.reuseIdentifier
            )
            return tableView
        case .grid:
            let nibName = UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
            layout.sectionInsetReference = .fromSafeArea
            
            let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(
                nibName,
                forCellWithReuseIdentifier: ProductsCollectionViewCell.reuseIdentifier
            )
            return collectionView
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
                self.showAlert(
                    title: "Network error",
                    message: "데이터를 불러오지 못했습니다.\n\(error.localizedDescription)"
                )
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {
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

extension MainViewController: UITableViewDelegate {
    func tableView(
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

extension MainViewController: UICollectionViewDataSource {
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

extension MainViewController: UICollectionViewDelegate {
    func collectionView(
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
