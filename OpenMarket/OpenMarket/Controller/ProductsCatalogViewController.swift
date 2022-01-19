import UIKit

class ProductsCatalogViewController: UIViewController {
    enum ViewType: Int {
        case list = 0
        case grid = 1
    }

    enum Section {
        case main
    }

    var presentView: ViewType = .list
    var pageNumber: Int = 1

    private var listCollectionView: UICollectionView! = nil
    private var gridCollectionView: UICollectionView! = nil
    private let indicator = UIActivityIndicatorView()
    private var listDataSource: UICollectionViewDiffableDataSource<Section, Product>!
    private var gridDataSource: UICollectionViewDiffableDataSource<Section, Product>!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()

        listCollectionView = configureHierarchy(type: presentView)
        configureDataSource(for: presentView)
        listCollectionView.delegate = self
        view = listCollectionView
        generateProductItems()

        configureIndicator()
    }
}

extension ProductsCatalogViewController {
    private func configureNavigationBar() {
        navigationItem.titleView = configureSegmentedControl()
        guard let image = UIImage(systemName: "plus") else {
            return
        }
        guard let cgImage = image.cgImage else {
            return
        }
        let resizedImage = UIImage(cgImage: cgImage, scale: 4, orientation: image.imageOrientation)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: resizedImage,
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.rightBarButtonItem?.width = 0
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    private func configureSegmentedControl() -> UISegmentedControl {
        let item = ["LIST", "GRID"]
        let segmentedControl = UISegmentedControl(items: item)

        segmentedControl.frame = CGRect(x: 0, y: 0, width: 170, height: 15)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.layer.borderWidth = 1
        segmentedControl.layer.borderColor = UIColor.systemBlue.cgColor
        let selectedText = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let defaultText = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        segmentedControl.setTitleTextAttributes(selectedText, for: .selected)
        segmentedControl.setTitleTextAttributes(defaultText, for: .normal)

        segmentedControl.addTarget(
            self,
            action: #selector(segmentedValueChanged),
            for: .valueChanged
        )

        return segmentedControl
    }

    @objc func segmentedValueChanged(sender: UISegmentedControl) {
        guard let viewType = ViewType(rawValue: sender.selectedSegmentIndex) else {
            return
        }
        switch viewType {
        case .list:
            view = listCollectionView
            listDataSource.apply(snapshot, animatingDifferences: false, completion: nil)
        case .grid:
            if gridCollectionView == nil {
                gridCollectionView = configureHierarchy(type: .grid)
                configureDataSource(for: .grid)
                gridCollectionView.delegate = self
            }
            view = gridCollectionView
            gridDataSource.apply(snapshot)
        }
        presentView = viewType
    }

    private func configureIndicator() {
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        indicator.startAnimating()
    }
}

extension ProductsCatalogViewController {
    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(270)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    private func createListLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }

    private func configureHierarchy(type: ViewType) -> UICollectionView {
        var layout: UICollectionViewLayout
        switch type {
        case .list:
            layout = createListLayout()
        case .grid:
            layout = createGridLayout()
        }
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white

        return collectionView
    }
}

extension ProductsCatalogViewController {
    private func configureDataSource(for viewType: ViewType) {
        switch viewType {
        case .list:
            let listCellRegistration = registerListCell()
            listDataSource = UICollectionViewDiffableDataSource<Section, Product>(
                collectionView: listCollectionView
            ) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: Product
            ) -> UICollectionViewCell? in
                return collectionView.dequeueConfiguredReusableCell(
                    using: listCellRegistration,
                    for: indexPath,
                    item: identifier
                )
            }
        case .grid:
            let gridCellRegistration = registerGridCell()
            gridDataSource = UICollectionViewDiffableDataSource<Section, Product>(
                collectionView: gridCollectionView
            ) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: Product
            ) -> UICollectionViewCell? in
                return collectionView.dequeueConfiguredReusableCell(
                    using: gridCellRegistration,
                    for: indexPath,
                    item: identifier
                )
            }
        }
    }

    private func registerGridCell() -> UICollectionView.CellRegistration<GridCell, Product> {
        let cellRegistration =
            UICollectionView.CellRegistration<GridCell, Product> { cell, indexPath, identifier in
                DispatchQueue.main.async {
                    if indexPath == self.gridCollectionView.indexPath(for: cell) {
                        cell.configure(product: identifier)
                    }
                }
            }
        return cellRegistration
    }

    private func registerListCell() -> UICollectionView.CellRegistration<ListCell, Product> {
        let cellRegistration =
            UICollectionView.CellRegistration<ListCell, Product> { cell, indexPath, identifier in
                DispatchQueue.main.async {
                    if indexPath == self.listCollectionView.indexPath(for: cell) {
                        cell.configure(product: identifier)
                    }
                }
            }
        return cellRegistration
    }

    private func generateProductItems() {
        if snapshot.numberOfSections == .zero {
            snapshot.appendSections([.main])
        }

        ProductService().retrieveProductList(
            pageNumber: pageNumber,
            itemsPerPage: 20,
            session: HTTPUtility.defaultSession
        ) { result in
            switch result {
            case .success(let productList):
                self.pageNumber += 1
                let products = productList.pages
                self.snapshot.appendItems(products)
                DispatchQueue.main.async {
                    switch self.presentView {
                    case .list:
                        self.listDataSource.apply(self.snapshot)
                    case .grid:
                        self.gridDataSource.apply(self.snapshot)
                    }
                    self.indicator.stopAnimating()
                }
            case .failure:
                return
            }
        }
    }
}

extension ProductsCatalogViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let targetOffset = targetContentOffset.pointee.y + view.frame.height
        let scrollViewHeight = scrollView.contentSize.height

        if targetOffset > scrollViewHeight {
            generateProductItems()
        }
    }
}
