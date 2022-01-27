//
//  ProductPageViewController.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/14.
//

import UIKit

final class ProductPageViewController: UIViewController {
    
    private(set) lazy var viewModel = ProductPageViewModel(viewHandler: self.updateUI)
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private let listCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: OpenMarketLayout.list.layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let gridCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: OpenMarketLayout.grid.layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var listDataSource: OpenMarketDiffableDataSource = {
        let dataSource = OpenMarketDiffableDataSource(
            collectionView: self.listCollectionView
        ) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(
                using: self.viewModel.listCellRegistration,
                for: indexPath,
                item: identifier
            )
        }
        return dataSource
    }()
    
    private lazy var gridDataSource: OpenMarketDiffableDataSource = {
        let dataSource = OpenMarketDiffableDataSource(
            collectionView: self.gridCollectionView
        ) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(
                using: self.viewModel.gridCellRegistration,
                for: indexPath,
                item: identifier
            )
        }
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegate()
        configureSegmentedConrol()
        configureRefreshControl()
        configureViewLayout()
        viewModel.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? ProductDetailViewController,
           let product = sender as? Product {
            detailVC.id = product.id
            detailVC.navigationItem.title = product.name
        }
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        viewModel.update()
        configureViewLayout()
    }
    
    @IBAction func unwindToProductPageViewController(_ sender: UIStoryboardSegue) { }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.activityIndicator?.startAnimating()
            let snapshot = self.viewModel.snapshot
            self.currentDataSource.apply(snapshot)
            self.activityIndicator?.stopAnimating()
        }
    }
    
}

// MARK: - ProductPageViewController Utilities
private extension ProductPageViewController {
    
    var currentCollectionView: UICollectionView {
        let contextIsListLayout = segmentedControl.isListLayout
        return contextIsListLayout ? listCollectionView : gridCollectionView
    }
    
    var oppositeCollectionView: UICollectionView {
        let contextIsGridLayout = !segmentedControl.isListLayout
        return contextIsGridLayout ? gridCollectionView : listCollectionView
    }
    
    var currentDataSource: OpenMarketDiffableDataSource {
        let contextIsListLayout = segmentedControl.isListLayout
        return contextIsListLayout ? listDataSource : gridDataSource
    }
    
    @objc
    func refreshDidTrigger() {
        viewModel.refresh()
        currentCollectionView.refreshControl?.endRefreshing()
    }
    
}

// MARK: - Updating Layout
private extension ProductPageViewController {
    
    func configureDelegate() {
        self.listCollectionView.delegate = self
        self.gridCollectionView.delegate = self
    }
    
    func configureSegmentedConrol() {
        segmentedControl.layer.borderColor = UIColor.systemBlue.cgColor
        segmentedControl.layer.borderWidth = 2
        [
            ([NSAttributedString.Key.foregroundColor: UIColor.white], UIControl.State.selected),
            ([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], UIControl.State.normal)
        ].forEach { segmentedControl.setTitleTextAttributes($0, for: $1) }
    }
    
    func configureRefreshControl() {
        let gridRefreshControl = UIRefreshControl()
        let listRefreshControl = UIRefreshControl()
        gridCollectionView.refreshControl = gridRefreshControl
        listCollectionView.refreshControl = listRefreshControl
        gridRefreshControl.addTarget(self, action: #selector(refreshDidTrigger) , for: .valueChanged)
        listRefreshControl.addTarget(self, action: #selector(refreshDidTrigger) , for: .valueChanged)
        gridCollectionView.addSubview(gridRefreshControl)
        listCollectionView.addSubview(listRefreshControl)
    }
    
    func configureViewLayout() {
        oppositeCollectionView.removeFromSuperview()
        view.addSubview(currentCollectionView)
        NSLayoutConstraint.activate([
            currentCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            currentCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            currentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            currentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }
    
}

// MARK: - Managing SegmentedControl Utilities
fileprivate extension UISegmentedControl {
    
    var isListLayout: Bool { selectedSegmentIndex == 0 }
    
}

// MARK: - UICollectionViewDelegate Protocol RequireMents
extension ProductPageViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomY = scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom
        if scrollView.contentOffset.y > bottomY {
            viewModel.nextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let snapshot = currentDataSource.snapshot()
        let item = snapshot.itemIdentifiers(inSection: 0)
        let index = indexPath.item
        let product = item[index]
        let segue = "productDetailSegue"
        performSegue(withIdentifier: segue, sender: product)
    }
    
}
