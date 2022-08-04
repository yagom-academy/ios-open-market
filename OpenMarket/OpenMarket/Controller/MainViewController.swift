//
//  MainViewController.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/14.
//
import UIKit

final class MainViewController: UIViewController {
    // MARK: - Instance Properties
    private let manager = NetworkManager.shared
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private var listDataSource: UICollectionViewDiffableDataSource<Section, Product>?
    private var gridDataSource: UICollectionViewDiffableDataSource<Section, Product>?
    private var listLayout: UICollectionViewLayout? = nil
    private var gridLayout: UICollectionViewLayout? = nil
    private var productListManager = ProductListManager()
    private var currentMaximumPage = 1
    private var refresher: UIRefreshControl!
    enum Section {
        case main
    }
    
    private var shouldHideListLayout: Bool? {
        didSet {
            guard let shouldHideListLayout = shouldHideListLayout else { return }
            guard let gridLayout = gridLayout, let listLayout = listLayout else { return }
            guard let gridSnapShot = gridDataSource?.snapshot(),
                  let listSnapShot = listDataSource?.snapshot() else { return }
            if shouldHideListLayout {
                if gridSnapShot.numberOfItems > listSnapShot.numberOfItems {
                    collectionView.dataSource = gridDataSource
                    collectionView.setCollectionViewLayout(gridLayout, animated: true) { _ in
                        self.loadData()
                    }
                } else {
                    gridDataSource?.apply(listSnapShot)
                    collectionView.dataSource = gridDataSource
                    collectionView.setCollectionViewLayout(gridLayout, animated: true) { _ in
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            } else {
                if gridSnapShot.numberOfItems < listSnapShot.numberOfItems {
                    collectionView.dataSource = listDataSource
                    collectionView.setCollectionViewLayout(listLayout, animated: true) { _ in
                        self.loadData()
                    }
                } else {
                    listDataSource?.apply(gridSnapShot)
                    collectionView.dataSource = listDataSource
                    collectionView.setCollectionViewLayout(listLayout, animated: true) { _ in
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    // MARK: - UI Properties
    private let segmentController: UISegmentedControl = {
        let segmentController = UISegmentedControl(items: ["List", "Grid"])
        segmentController.translatesAutoresizingMaskIntoConstraints = false
        segmentController.selectedSegmentIndex = 0
        segmentController.tintColor = .systemBlue
        segmentController.backgroundColor = .systemBlue
        return segmentController
    }()
    
    private lazy var activitiIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.red
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applyDataSource),
                                               name: .addProductList, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadData),
                                               name: .refresh, object: nil)
        initializeViewController()
        self.listLayout = createListLayout()
        self.gridLayout = createGridLayout()
        addUIComponents()
        setupSegment()
        configureListDataSource()
        configureGridDataSource()
        configureHierarchy()
        setupRefreshController()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    // MARK: - @objc method
    @objc private func addButtonDidTapped() {
        print("add button tapped")
        let prodcutDetailVC = ProductSetupViewController()
        prodcutDetailVC.viewControllerTitle = "상품 등록"
        navigationController?.pushViewController(prodcutDetailVC, animated: true)
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        self.shouldHideListLayout = segment.selectedSegmentIndex != 0
    }
    
    @objc private func applyDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(productListManager.getCurrentList())
        snapshot.reloadItems(productListManager.getCurrentList())
        guard let shouldHideListLayout = shouldHideListLayout else {
            return
        }
        if shouldHideListLayout {
            self.gridDataSource?.apply(snapshot, animatingDifferences: false)
        } else {
            self.listDataSource?.apply(snapshot, animatingDifferences: false)
        }
        DispatchQueue.main.async {
            self.activitiIndicator.stopAnimating()
            self.collectionView.alpha = 1
        }
    }
    // MARK: - MainVC - Private method
    private func initializeViewController() {
        DispatchQueue.main.async {
            self.collectionView.alpha = 0
            self.activitiIndicator.startAnimating()
        }
        self.view.backgroundColor = .systemBackground
    }
    
    private func addUIComponents() {
        self.view.addSubview(collectionView)
        self.view.addSubview(activitiIndicator)
        self.navigationItem.titleView = segmentController
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(addButtonDidTapped))
    }
    
    private func setupSegment() {
        didChangeValue(segment: self.segmentController)
        self.segmentController.addTarget(self,
                                         action: #selector(didChangeValue(segment:)),
                                         for: .valueChanged)
    }
    
    private func fetchData() {
        manager.requestProductPage(at: 1) { [weak self] productList in
            self?.productListManager.update(list: productList)
        }
    }
    
    private func addData() {
        manager.requestProductPage(at: currentMaximumPage) { [weak self] productList in
            self?.productListManager.add(list: productList)
        }
    }
}
// MARK: - Modern Collection Create Layout
extension MainViewController {
    private func createListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
// MARK: - Modern Collection VIew Configure Datasource
extension MainViewController {
    // MARK: - @objc method
    @objc private func loadData() {
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.beginRefreshing()
        }
        currentMaximumPage = 1
        fetchData()
        stopRefresher()
    }
    // MARK: - ProductSetupVC - Private method
    private func configureListDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ListCell, Product> { (cell, indexPath, product) in
            cell.setup(with: product)
        }
        listDataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Product) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    private func configureGridDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<GridCell, Product> { (cell, indexPath, product) in
            cell.setup(with: product)
        }
        gridDataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Product) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    private func configureHierarchy() {
        collectionView.frame = view.bounds
        guard let listLayout = listLayout else {
            return
        }
        collectionView.setCollectionViewLayout(listLayout, animated: true)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.dataSource = listDataSource
        collectionView.delegate = self
    }
    
    private func setupRefreshController() {
        self.refresher = UIRefreshControl()
        self.collectionView.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.collectionView.refreshControl = refresher
    }
    
    
    
    private func stopRefresher() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.7) {
            self.refresher.endRefreshing()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if collectionView.contentOffset.y > collectionView.contentSize.height - collectionView.bounds.size.height {
            print("앙 바닥에 닿았당")
            DispatchQueue.main.async { [weak self] in
                print("다음 페이지")
                self?.currentMaximumPage += 1
                self?.addData()
                self?.collectionView.reloadData()
            }
        }
    }
    
}
// MARK: - Modern Collection View Delegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let prodcutDetailVC = ProductDetailViewController()
        let seletedProduct = productListManager.getCurrentList()[indexPath.row]
        prodcutDetailVC.productId = seletedProduct.id
        prodcutDetailVC.viewControllerTitle = seletedProduct.name
        print("\(seletedProduct.id) - \(seletedProduct.name) is tapped")
        navigationController?.pushViewController(prodcutDetailVC, animated: true)
    }
}


