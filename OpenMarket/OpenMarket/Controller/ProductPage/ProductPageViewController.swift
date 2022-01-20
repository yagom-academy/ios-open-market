//
//  ProductPageViewController.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/14.
//

import UIKit

final class ProductPageViewController: UIViewController {
    
    var dataManager = ProductPageDataManager()
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl?
    @IBOutlet private var activityIndicator: UIActivityIndicatorView?
    
    private var currentCollectionView: UICollectionView?
    
    private let listCollectionView: UICollectionView
    private let gridCollectionView: UICollectionView
    
    private var listDataSource: OpenMarketDiffableDataSource?
    private var gridDataSource: OpenMarketDiffableDataSource?
    
    private let listCellRegistration: OpenMarketListCellRegistration
    private let gridCellRegistration: OpenMarketGridCellRegistration
    
    func dataManagerDidChanged() {
        let snapshot = createSnapshot()
        updateUI(with: snapshot)
    }
    
    required init?(coder: NSCoder) {
        self.listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: OpenMarketLayout.list.layout)
        self.gridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: OpenMarketLayout.grid.layout)
        
        self.listCellRegistration = OpenMarketListCellRegistration { (cell, indexPath, item) in
            cell.configureContents(at: indexPath, with: item)
            
            cell.layer.borderWidth = 0.3
            cell.layer.borderColor = UIColor.systemGray.cgColor
        }
        
        self.gridCellRegistration = OpenMarketGridCellRegistration { (cell, indexPath, item) in
            cell.configureContents(at: indexPath, with: item)
            
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.systemGray.cgColor
        }
        
        super.init(coder: coder)
        
        self.gridDataSource = OpenMarketDiffableDataSource(
            collectionView: self.gridCollectionView
        ) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(
                using: self.gridCellRegistration,
                for: indexPath,
                item: identifier
            )
        }
        self.listDataSource = OpenMarketDiffableDataSource(
            collectionView: self.listCollectionView
        ) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(
                using: self.listCellRegistration,
                for: indexPath,
                item: identifier
            )
        }
        
        self.listCollectionView.delegate = self
        self.gridCollectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataManager.dataChangedHandler = dataManagerDidChanged
        
        configureActivityIndicator()
        configureSegmentedConrol()
        configureRefreshControl()
        configureViewLayout()
        
        dataManager.update()
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        dataManager.update()
        configureViewLayout()
    }
    
    @IBAction func createButtonClicked(_ sender: UIBarButtonItem) {
        let createProductSegue = "productCreateModifySeque"
        performSegue(withIdentifier: createProductSegue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? UINavigationController else {
            return
        }
        
        destination.topViewController?.navigationItem.title = "상품등록"
    }
    
}

// MARK: - UIRefreshControl Action
private extension ProductPageViewController {
    
    @objc
    func refreshDidTrigger() {
        dataManager.reset()
        dataManager.update()
        currentCollectionView?.refreshControl?.endRefreshing()
    }
    
}

// MARK: - UICollectionViewDelegate Protocol RequireMents
extension ProductPageViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomY = scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom
        
        if scrollView.contentOffset.y > bottomY {
            dataManager.requestNextPage()
        }
    }
    
}

// MARK: - Updating Layout
private extension ProductPageViewController {
    
    func configureActivityIndicator() {
        guard let activityIndicator = activityIndicator else { return }
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.startAnimating()
    }
    
    func configureSegmentedConrol() {
        guard let segmentedControl = segmentedControl else { return }
        
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.backgroundColor = .systemBackground
        
        segmentedControl.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.white],
            for: UIControl.State.selected
        )
        segmentedControl.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.systemBlue],
            for: UIControl.State.normal
        )
        
        segmentedControl.layer.borderColor = UIColor.systemBlue.cgColor
        segmentedControl.layer.borderWidth = 2
    }
    
    func configureRefreshControl() {
        let refreshControl1 = UIRefreshControl()
        let refreshControl2 = UIRefreshControl()
        gridCollectionView.refreshControl = refreshControl1
        listCollectionView.refreshControl = refreshControl2
        refreshControl1.addTarget(self, action: #selector(refreshDidTrigger) , for: .valueChanged)
        refreshControl2.addTarget(self, action: #selector(refreshDidTrigger) , for: .valueChanged)
        gridCollectionView.addSubview(refreshControl1)
        listCollectionView.addSubview(refreshControl2)
    }
    
    func configureViewLayout() {
        if currentCollectionView != nil {
            currentCollectionView?.removeFromSuperview()
        }
        
        guard let segmentedControl = segmentedControl else { return }
        
        if segmentedControl.isListLayout {
            currentCollectionView = listCollectionView
        } else {
            currentCollectionView = gridCollectionView
        }
        
        guard let collectionView = currentCollectionView else { return }
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }
    
    func updateUI(with snapshot: OpenMarketSnapshot) {
        guard let segmentedControl = segmentedControl else { return }
        
        self.activityIndicator?.startAnimating()
        
        if segmentedControl.isListLayout {
            listDataSource?.apply(snapshot)
        } else {
            gridDataSource?.apply(snapshot)
        }

        self.activityIndicator?.stopAnimating()
    }
    
}

// MARK: - Managing Item Data
private extension ProductPageViewController {
    
    func createSnapshot() -> OpenMarketSnapshot {
        var snapshot = OpenMarketSnapshot()
        let products = dataManager.products
        snapshot.appendSections([0])
        snapshot.appendItems(products)
        return snapshot
    }
    
}

// MARK: - Managing typealias
private extension ProductPageViewController {
    
    typealias OpenMarketDiffableDataSource = UICollectionViewDiffableDataSource<Int, Product>
    typealias OpenMarketSnapshot = NSDiffableDataSourceSnapshot<Int, Product>
    typealias OpenMarketCellRegistration = UICollectionView.CellRegistration
    typealias OpenMarketListCellRegistration = OpenMarketCellRegistration<OpenMarketListCollectionViewCell, Product>
    typealias OpenMarketGridCellRegistration = OpenMarketCellRegistration<OpenMarketGridCollectionViewCell, Product>
    
}

// MARK: - Managing SegmentedControl Utilities
fileprivate extension UISegmentedControl {
    
    var isListLayout: Bool {
        return self.selectedSegmentIndex == 0
    }
    
}

extension ProductPageViewController {
    
    @IBAction func unwindToProductPageViewController(_ sender: UIStoryboardSegue) {
    }
    
}
