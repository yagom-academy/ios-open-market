import UIKit

class ProductsViewController: UIViewController {
    
    // MARK: - Properties
    
    private var collectionView: UICollectionView?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Page>()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Page>?
    
    private var productImages: [UIImage] = []
    
    private var currentPage = 0
    private var isFetchingEnd = true
    
    private let refreshControl = UIRefreshControl()
    private var segmentControl: UISegmentedControl?
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.backgroundColor = .black.withAlphaComponent(0.3)
        indicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        return indicator
    }()
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureDataSoure()
        configureSegmentControl()
        configureRefreshControl()
        addIndicatorLayout()
        configureNavigationBarRightButton()

        activityIndicator.startAnimating()
        startFetching() {
            self.activityIndicator.stopAnimating()
        }
    }
}

// MARK: - Fetching Method

extension ProductsViewController {
    private func startFetching(completion: @escaping () -> ()) {
        isFetchingEnd = false
        ProductsDataManager.shared.getData(pageNumber: currentPage + 1, itemsPerPage: 20) { [self] (products: Products) in
            products.pages.forEach {
                guard let imageUrl = URL(string: $0.thumbnail),
                      let imageData = try? Data(contentsOf: imageUrl),
                      let image = UIImage(data: imageData) else { return }
                productImages.append(image)
            }
            
            if currentPage == 0 { snapshot.appendSections([.main]) }
            snapshot.appendItems(products.pages)
            currentPage = products.pageNo
            
            DispatchQueue.main.async { [self] in
                dataSource?.apply(snapshot, animatingDifferences: true)
                isFetchingEnd = true
                
                completion()
            }
        }
    }
}

// MARK: - Configure Method

extension ProductsViewController {
    private func configureSegmentControl() {
        segmentControl = UISegmentedControl(items: Titles.toString)
        
        guard let segmentControl = segmentControl else { return }
        
        segmentControl.setDefaultFontColor(.systemBlue)
        segmentControl.setSelectedFontColor(.white)
        segmentControl.selectedSegmentTintColor = .systemBlue
        segmentControl.selectedSegmentIndex = Titles.list.rawValue
        
        segmentControl.setWidth(100, forSegmentAt: 0)
        segmentControl.setWidth(100, forSegmentAt: 1)
        
        segmentControl.backgroundColor = .white
        segmentControl.layer.borderWidth = 1.0
        segmentControl.layer.cornerRadius = 5.0
        segmentControl.layer.masksToBounds = true
        segmentControl.layer.borderColor = UIColor.systemBlue.cgColor
        
        segmentControl.addTarget(self, action: #selector(changeLayout), for: .valueChanged)
        
        navigationItem.titleView = segmentControl
    }
    
    private func configureRefreshControl() {
        refreshControl.backgroundColor = .systemGray5
        refreshControl.attributedTitle = NSAttributedString(string: "새로고침")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        collectionView?.refreshControl = refreshControl
    }
    
    private func configureNavigationBarRightButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(showDetailView))
    }
    
    @objc func showDetailView() {
        let detailViewController = ProductsDetailViewController()
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createListLayout())
        collectionView?.backgroundColor = .white
        collectionView?.delegate = self
        
        guard let collectionView = collectionView else { return }
        
        view.addSubview(collectionView)
    }
    
    private func configureDataSoure() {
        let cellRegistration = UICollectionView.CellRegistration<ItemCollectionViewCell, Page> { [self] (cell, indexPath, identifier) in
            cell.setProduct(by: identifier)
            
            guard let segmentControl = self.segmentControl,
                  let currentSeguement = Titles(rawValue: segmentControl.selectedSegmentIndex) else { return }
            cell.setAxis(segment: currentSeguement)
            
            if productImages.count > indexPath.row {
                cell.setImage(by: productImages[indexPath.row])
            }
            
            cell.backgroundColor = .systemBackground
        }
        
        guard let collectionView = collectionView else { return }
        dataSource = UICollectionViewDiffableDataSource<Section, Page>(collectionView: collectionView)
        { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
}

// MARK: - Layout Method

extension ProductsViewController {
    private func createListLayout() -> UICollectionViewLayout {
        let flowLayout = UICollectionViewFlowLayout()
        
        let width = view.frame.width
        let height = view.frame.height
        
        flowLayout.minimumLineSpacing = 2
        flowLayout.estimatedItemSize = CGSize(width: width, height: height * 0.08)
        
        return flowLayout
    }
    
    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.31))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 2)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func addIndicatorLayout() {
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - SegmentControl Method

extension ProductsViewController {
    @objc private func changeLayout() {
        if segmentControl?.selectedSegmentIndex == Titles.list.rawValue {
            isFetchingEnd = false
            collectionView?.setCollectionViewLayout(createListLayout(), animated: true) { [self] bool in
                isFetchingEnd = true
            }
            collectionView?.visibleCells.forEach { cell in
                guard let cell = cell as? ItemCollectionViewCell else { return }
                cell.setAxis(segment: .list)
            }
        } else if segmentControl?.selectedSegmentIndex == Titles.grid.rawValue {
            isFetchingEnd = false
            collectionView?.setCollectionViewLayout(createGridLayout(), animated: true) { [self] bool in
                isFetchingEnd = true
            }
            collectionView?.visibleCells.forEach { cell in
                guard let cell = cell as? ItemCollectionViewCell else { return }
                cell.setAxis(segment: .grid)
            }
        }
    }
}

// MARK: - RefreshControl Method

extension ProductsViewController {
    @objc private func refresh() {
        snapshot.deleteAllItems()
        productImages.removeAll()
        
        currentPage = 0
        
        if isFetchingEnd {
            startFetching() { [self] in
                refreshControl.endRefreshing()
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension ProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height - scrollView.frame.height
        
        if offsetY > contentHeight && isFetchingEnd {
            activityIndicator.startAnimating()
            startFetching() { [self] in
                activityIndicator.stopAnimating()
            }
        }
    }
}
