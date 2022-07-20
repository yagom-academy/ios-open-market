import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private var collectionView: UICollectionView?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Page>()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Page>?
    
    private let productsDataManager = ProductsDataManager()
    private var productImages: [UIImage] = []
    private var products: Products? {
        didSet {
            products?.pages.forEach {
                guard let imageUrl = URL(string: $0.thumbnail),
                      let imageData = try? Data(contentsOf: imageUrl),
                      let image = UIImage(data: imageData) else { return }
                productImages.append(image)
            }
        }
    }
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureDataSoure()
        configureSegmentControl()
        configureRefreshControl()
        configureIndicatorLayout()
        configureNavigationBarRightButton()
        
        activityIndicator.startAnimating()
        startFetching() {
            self.activityIndicator.stopAnimating()
        }
    }
}


// MARK: - Functions

extension ViewController {
    private func startFetching(completion: @escaping () -> ()) {
        isFetchingEnd = false
        productsDataManager.getData(pageNumber: currentPage + 1, itemsPerPage: 20) { (result: Products) in
            
            self.products = result
            guard let products = self.products else { return }
            
            if self.currentPage == 0 { self.snapshot.appendSections([.main]) }
            self.snapshot.appendItems(products.pages)
            self.currentPage = result.pageNo
            
            DispatchQueue.main.async {
                self.dataSource?.apply(self.snapshot, animatingDifferences: true)
                self.isFetchingEnd = true
                
                completion()
            }
        }
    }
}

extension ViewController {
    private func configureSegmentControl() {
        segmentControl = UISegmentedControl(items: Titles.toString)
        
        segmentControl?.defaultConfiguration(color: .systemBlue)
        segmentControl?.selectedConfiguration(color: .white)
        segmentControl?.selectedSegmentTintColor = .systemBlue
        segmentControl?.selectedSegmentIndex = Titles.LIST.rawValue
        
        segmentControl?.setWidth(100, forSegmentAt: 0)
        segmentControl?.setWidth(100, forSegmentAt: 1)
        
        segmentControl?.backgroundColor = .white
        segmentControl?.layer.borderWidth = 1.0
        segmentControl?.layer.cornerRadius = 5.0
        segmentControl?.layer.masksToBounds = true
        segmentControl?.layer.borderColor = UIColor.systemBlue.cgColor
        
        segmentControl?.addTarget(self, action: #selector(changeLayout), for: .valueChanged)
        
        navigationItem.titleView = segmentControl
    }
    
    private func configureRefreshControl() {
        refreshControl.backgroundColor = .systemGray5
        refreshControl.attributedTitle = NSAttributedString(string: "새로고침")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        collectionView?.refreshControl = refreshControl
    }
    
    private func configureNavigationBarRightButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: nil)
    }
}

extension ViewController {
    private func createListLayout() -> UICollectionViewLayout {
        let flowLayout = UICollectionViewFlowLayout()
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        flowLayout.minimumLineSpacing = 2
        flowLayout.estimatedItemSize = CGSize(width: width, height: height * 0.08)
        
        return flowLayout
    }
    
    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.31))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureIndicatorLayout() {
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

extension ViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createListLayout())
        collectionView?.backgroundColor = .white
        collectionView?.delegate = self
        
        guard let collectionView = collectionView else { return }
        
        view.addSubview(collectionView)
    }
    
    private func configureDataSoure() {
        let cellRegistration = UICollectionView.CellRegistration<ItemCollectionViewCell, Page> { (cell, indexPath, identifier) in
            cell.setProduct(by: identifier)
            
            guard let segmentControl = self.segmentControl,
                  let currentSeguement = Titles(rawValue: segmentControl.selectedSegmentIndex) else { return }
            cell.setAxis(segment: currentSeguement)
            
            if self.productImages.count > indexPath.row {
                cell.setImage(by: self.productImages[indexPath.row])
            }
            
            cell.backgroundColor = .systemBackground
        }
        
        guard let collectionView = collectionView else { return }
        dataSource = UICollectionViewDiffableDataSource<Section, Page>(collectionView: collectionView) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
}

extension ViewController {
    @objc private func changeLayout() {
        if segmentControl?.selectedSegmentIndex == Titles.LIST.rawValue {
            isFetchingEnd = false
            self.collectionView?.setCollectionViewLayout(createListLayout(), animated: true) { bool in
                self.isFetchingEnd = true
            }
            collectionView?.visibleCells.forEach { cell in
                guard let cell = cell as? ItemCollectionViewCell else { return }
                cell.setAxis(segment: .LIST)
            }
        } else if segmentControl?.selectedSegmentIndex == Titles.GRID.rawValue {
            isFetchingEnd = false
            self.collectionView?.setCollectionViewLayout(createGridLayout(), animated: true) { bool in
                self.isFetchingEnd = true
            }
            collectionView?.visibleCells.forEach { cell in
                guard let cell = cell as? ItemCollectionViewCell else { return }
                cell.setAxis(segment: .GRID)
            }
        }
    }
}

extension ViewController {
    @objc private func refresh(_ sender: AnyObject) {
        snapshot.deleteAllItems()
        productImages.removeAll()
        
        currentPage = 0
        
        if isFetchingEnd {
            startFetching() {
                self.refreshControl.endRefreshing()
            }
        }
    }
}


// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height - scrollView.frame.height
        
        if offsetY > contentHeight {
            if isFetchingEnd {
                activityIndicator.startAnimating()
                startFetching() {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}
