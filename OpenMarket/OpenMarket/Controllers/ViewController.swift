import UIKit

class ViewController: UIViewController {
    var segmentControl: UISegmentedControl?
    var collectionView: UICollectionView?
    var dataSource: UICollectionViewDiffableDataSource<Section, Page>?
    var snapshot = NSDiffableDataSourceSnapshot<Section, Page>()
    var productImages: [UIImage] = []
    let productsDataManager = ProductsDataManager()
    var isFetchingEnd = true
    var currentPage = 0
    var currentLastPage: Page?
    var Products: Products? {
        didSet {
            Products?.pages.forEach {
                guard let imageUrl = URL(string: $0.thumbnail),
                      let imageData = try? Data(contentsOf: imageUrl),
                      let image = UIImage(data: imageData) else { return }
                productImages.append(image)
            }
        }
    }
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        indicator.backgroundColor = .black.withAlphaComponent(0.3)
        return indicator
    }()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureDataSoure()
        configureSegmentControl()
        configureNavigationBarRightButton()
        setupCollectionViewLayout()
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        activityIndicator.startAnimating()
        isFetchingEnd = false
        productsDataManager.getData(pageNumber: 1, itemsPerPage: 20) { (result: Products) in
            self.Products = result
            self.currentPage = result.pageNo
            self.snapshot.appendSections([.main])

            guard let Products = self.Products else {
                return
            }
            self.currentLastPage = result.pages.last
            self.snapshot.appendItems(Products.pages)
            
            DispatchQueue.main.async {
                self.dataSource?.apply(self.snapshot, animatingDifferences: false)
                self.activityIndicator.stopAnimating()
                self.isFetchingEnd = true
            }
        }
        refreshControl.backgroundColor = .systemGray5
        refreshControl.attributedTitle = NSAttributedString(string: "새로고침")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        collectionView?.refreshControl = refreshControl
    }
    
    @objc func refresh(_ sender: AnyObject) {
        snapshot.deleteAllItems()
        productImages.removeAll()
        if isFetchingEnd {
            isFetchingEnd = false
            productsDataManager.getData(pageNumber: 1, itemsPerPage: 20) { (result: Products) in
                self.isFetchingEnd = false
                self.Products = result
                self.currentPage = 1
                self.snapshot.appendSections([.main])
                
                guard let Products = self.Products else {
                    return
                }
                self.currentLastPage = result.pages.last
                self.snapshot.appendItems(Products.pages)
                
                DispatchQueue.main.async {
                    self.dataSource?.apply(self.snapshot, animatingDifferences: false)
                    self.refreshControl.endRefreshing()
                    self.isFetchingEnd = true
                }
            }
        }
    }
        
    private func setupCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()

        let width = self.view.frame.width
        let height = self.view.frame.height

        flowLayout.minimumLineSpacing = 2
        flowLayout.estimatedItemSize = CGSize(width: width, height: height * 0.08)

        collectionView?.collectionViewLayout = flowLayout
//        collectionView?.backgroundColor = .systemGray
    }
}

extension ViewController {
    private func configureSegmentControl() {
        segmentControl = UISegmentedControl(items: Titles.toString)
        segmentControl?.selectedSegmentIndex = Titles.LIST.rawValue
        segmentControl?.addTarget(self, action: #selector(changeLayout), for: .valueChanged)
        segmentControl?.backgroundColor = .white
        segmentControl?.selectedSegmentTintColor = .systemBlue
        segmentControl?.defaultConfiguration(color: .systemBlue)
        segmentControl?.selectedConfiguration(color: .white)
        segmentControl?.layer.borderWidth = 1.0
        segmentControl?.layer.cornerRadius = 5.0
        segmentControl?.layer.borderColor = UIColor.systemBlue.cgColor
        segmentControl?.layer.masksToBounds = true
        segmentControl?.setWidth(100, forSegmentAt: 0)
        segmentControl?.setWidth(100, forSegmentAt: 1)
        
        navigationItem.titleView = segmentControl
    }
    
    private func configureNavigationBarRightButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: nil)
    }
}

extension ViewController {
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
    
    private func createListLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
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
            cell.product = identifier
            guard let currentSeguement = Titles(rawValue: self.segmentControl!.selectedSegmentIndex) else { return }
            cell.setAxis(segment: currentSeguement)
            
            if self.productImages.count > indexPath.row {
                cell.itemImageView.image = self.productImages[indexPath.row]
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
            setupCollectionViewLayout()
            collectionView?.visibleCells.forEach{ cell in
                guard let cell = cell as? ItemCollectionViewCell else { return }
                cell.setAxis(segment: .LIST)
            }
        } else if segmentControl?.selectedSegmentIndex == Titles.GRID.rawValue {
            isFetchingEnd = false
            self.collectionView?.setCollectionViewLayout(createGridLayout(), animated: true) { bool in
                self.isFetchingEnd = true
            }
            collectionView?.visibleCells.forEach{ cell in
                guard let cell = cell as? ItemCollectionViewCell else { return }
                cell.setAxis(segment: .GRID)
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height - scrollView.frame.height
        
        if offsetY > contentHeight {
            if isFetchingEnd {
                print("새로고침")
                activityIndicator.startAnimating()
                isFetchingEnd = false
                productsDataManager.getData(pageNumber: currentPage + 1, itemsPerPage: 20) { (result: Products) in
                    self.currentPage = result.pageNo
                    self.snapshot.insertItems(result.pages, afterItem: self.currentLastPage!)
                    
                    result.pages.forEach {
                        guard let imageURL = URL(string: $0.thumbnail),
                              let dataURL = try? Data(contentsOf: imageURL),
                              let image = UIImage(data: dataURL) else { return }
                        self.productImages.append(image)
                    }
                    
                    self.currentLastPage = result.pages.last
                        
                    DispatchQueue.main.async {
                        self.dataSource?.apply(self.snapshot)
                        self.activityIndicator.stopAnimating()
                        self.isFetchingEnd = true
                    }
                }
            }
        }
    }
}
