//
//  ProductPageViewController.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/14.
//

import UIKit

final class ProductPageViewController: UIViewController {
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl?
    @IBOutlet private var activityIndicator: UIActivityIndicatorView?
    
    private let datamanager = DataManager()
    private var snapshot = NSDiffableDataSourceSnapshot<Int, Product>()
    
    private var currentCollectionView: UICollectionView?
    
    private let listCollectionView: UICollectionView
    private let gridCollectionView: UICollectionView
    private var listDataSource: OpenMarketDiffableDataSource?
    private var gridDataSource: OpenMarketDiffableDataSource?
    private let listCellRegistration: OpenMarketListCellRegistration
    private let gridCellRegistration: OpenMarketGridCellRegistration
    
    required init?(coder: NSCoder) {
        self.listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: OpenMarketLayout.list.layout)
        self.gridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: OpenMarketLayout.grid.layout)
        
        self.listCellRegistration = OpenMarketListCellRegistration { (cell, indexPath, item) in
            cell.configureContents(with: item)
            
            cell.layer.borderWidth = 0.3
            cell.layer.borderColor = UIColor.systemGray.cgColor
        }
        
        self.gridCellRegistration = OpenMarketGridCellRegistration { (cell, indexPath, item) in
            cell.configureContents(with: item)
            
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.systemGray.cgColor
        }
        
        self.snapshot.appendSections([0])
        
        super.init(coder: coder)
        
        self.gridDataSource = OpenMarketDiffableDataSource(collectionView: self.gridCollectionView) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: self.gridCellRegistration, for: indexPath, item: identifier)
        }
        self.listDataSource = OpenMarketDiffableDataSource(collectionView: self.listCollectionView) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: self.listCellRegistration, for: indexPath, item: identifier)
        }
        
        self.listCollectionView.delegate = self
        self.gridCollectionView.delegate = self
        self.datamanager.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let activityIndicator = activityIndicator else { return }
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        configureSegmentedConrol()
        configureRefreshControl()
        configureViewLayout()
        view.bringSubviewToFront(activityIndicator)
        datamanager.update()
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        configureViewLayout()
        applyDataToCurrentView()
    }
}

// MARK: - DataRepresentable Protocol RequireMents
extension ProductPageViewController: DataRepresentable {
    
    func dataDidChange(data: [Product]) {
        snapshot.appendItems(data)
        applyDataToCurrentView()
    }
    
}

// MARK: - UICollectionViewDelegate Protocol RequireMents
extension ProductPageViewController: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let endPoint = CGPoint(x: 0, y: scrollView.contentSize.height)
        if targetContentOffset.pointee.y + scrollView.frame.height >= endPoint.y {
            datamanager.nextPage()
            applyDataToCurrentView()
        }
    }
    
}

// MARK: - Updating Layout
extension ProductPageViewController {
    
    private func configureSegmentedConrol() {
        
        guard let segmentedControl = segmentedControl else { return }
        
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.backgroundColor = UIColor(cgColor: CGColor(red: 255, green: 255, blue: 255, alpha: 0))
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: UIControl.State.normal)
        
        segmentedControl.layer.borderColor = UIColor.systemBlue.cgColor
        segmentedControl.layer.borderWidth = 2
    }
    
    private func configureRefreshControl() {
        let refreshControl1 = UIRefreshControl()
        let refreshControl2 = UIRefreshControl()
        gridCollectionView.refreshControl = refreshControl1
        listCollectionView.refreshControl = refreshControl2
        refreshControl1.addTarget(self, action: #selector(refreshDidTrigger) , for: .valueChanged)
        refreshControl2.addTarget(self, action: #selector(refreshDidTrigger) , for: .valueChanged)
        gridCollectionView.addSubview(refreshControl1)
        listCollectionView.addSubview(refreshControl2)
    }
    
    @objc
    func refreshDidTrigger() {
        datamanager.update()
        
        DispatchQueue.main.async {
            self.currentCollectionView?.refreshControl?.endRefreshing()
        }
    }
    
    func configureViewLayout() {
        if currentCollectionView != nil {
            currentCollectionView?.removeFromSuperview()
        }
        
        guard let segmentedControl = segmentedControl else { return }
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            currentCollectionView = listCollectionView
        default:
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
    
    private func applyDataToCurrentView() {
        DispatchQueue.main.async {
            self.segmentedControl?.selectedSegmentIndex == 0 ?
            self.listDataSource?.apply(self.snapshot)
            : self.gridDataSource?.apply(self.snapshot)
            
            self.activityIndicator?.stopAnimating()
        }
    }
    
    private func createDiffableDataSorce(with view: UICollectionView, layout: OpenMarketLayout) -> OpenMarketDiffableDataSource {
        OpenMarketDiffableDataSource(collectionView: view) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
           
            switch layout {
            case .list:
                return collectionView.dequeueConfiguredReusableCell(using: self.listCellRegistration, for: indexPath, item: identifier)
            case .grid:
                return collectionView.dequeueConfiguredReusableCell(using: self.gridCellRegistration, for: indexPath, item: identifier)
            }
       }
    }
    
}

private extension ProductPageViewController {
    
    typealias OpenMarketDiffableDataSource = UICollectionViewDiffableDataSource<Int, Product>
    typealias OpenMarketListCellRegistration = UICollectionView.CellRegistration<OpenMarketListCollectionViewCell, Product>
    typealias OpenMarketGridCellRegistration = UICollectionView.CellRegistration<OpenMarketGridCollectionViewCell, Product>
    
}
