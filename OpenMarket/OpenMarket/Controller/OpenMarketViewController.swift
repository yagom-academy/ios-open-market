//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

fileprivate enum Const {
    static let error = "ERROR"
    static let loding = "Loading Data"
    static let itemPerPage = 20
}

final class OpenMarketViewController: UIViewController {
    private let segmentControl = SegmentControl(items: LayoutType.inventory)
    private var layoutType = LayoutType.list
    private var collectionView: UICollectionView?
    private var page = 1
    private var network: URLSessionProvider<ProductList>?
    private var productList: [DetailProduct]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        network = URLSessionProvider()
        fetchData(from: .productList(page: page, itemsPerPage: Const.itemPerPage))
        setupCollectionView()
        setupSegmentControl()
        setupAddButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.collectionView?.reloadData()
        self.fetchData(from: .productList(page: page, itemsPerPage: Const.itemPerPage))
    }
    
    private func fetchData(from: Endpoint) {
        network?.fetchData(from: from, completionHandler: { result in
            switch result {
            case .success(let data):
                self.productList = data.pages
            case .failure(let error):
                self.showAlert(title: Const.error, message: error.errorDescription)
            }
        })
    }
}

// MARK: - NavigationBar

extension OpenMarketViewController {
    
    private func setupAddButton() {
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddButton))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func didTapAddButton() {
        let productRegistrationVC = UINavigationController(
            rootViewController: RegistrationViewController()
        )
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        productRegistrationVC.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        productRegistrationVC.modalPresentationStyle = .fullScreen
        self.present(productRegistrationVC, animated: true)
    }
    
    private func setupSegmentControl() {
        self.navigationItem.titleView = segmentControl
        segmentControl.addTarget(self, action: #selector(didChangeSegment), for: .valueChanged)
    }
    
    @objc private func didChangeSegment(_ sender: UISegmentedControl) {
        
        if let currentLayout = LayoutType(rawValue: sender.selectedSegmentIndex) {
            layoutType = currentLayout
        }
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
}

// MARK: - CollectionView

extension OpenMarketViewController {
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
        view.addSubview(collectionView ?? UICollectionView())
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemPink
        refreshControl.attributedTitle = NSAttributedString(string: Const.loding, attributes: [.foregroundColor: UIColor.systemPink])
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
        collectionView?.register(GridCell.self, forCellWithReuseIdentifier: GridCell.identifier)
    }
    
    @objc func pullToRefresh() {
        self.fetchData(from: .productList(page: page, itemsPerPage: Const.itemPerPage))
        self.collectionView?.refreshControl?.endRefreshing()
    }
    
    private func paging(from: Endpoint) {
        
        network?.fetchData(from: from, completionHandler: { [weak self] result in
            switch result {
            case .success(let data):
                data.pages?.forEach { self?.productList?.append($0) }
            case .failure(let error):
                self?.showAlert(title: Const.error, message: error.errorDescription)
            }
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset < currentOffset {
            page += 1
            paging(from: .productList(page: page, itemsPerPage: Const.itemPerPage))
        }
    }
}

// MARK: - CollectionView DataSource, Delegate

extension OpenMarketViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let product = productList?[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: layoutType.cell.identifier,
            for: indexPath) as? CustomCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(data: product)
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return productList?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = productList?[indexPath.item] else {
            return
        }
        
        let reviseController = UINavigationController(rootViewController: EditViewController(product: product))
        reviseController.modalPresentationStyle = .fullScreen
        
        self.present(reviseController, animated: true)
    }
    
}

// MARK: - FlowLayout

extension OpenMarketViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        switch layoutType {
        case .list:
            return CGSize(width: view.frame.width, height: view.frame.height / 14)
        case .grid:
            return CGSize(width: view.frame.width / 2.2, height: view.frame.height / 3)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        
        switch layoutType {
        case .list:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .grid:
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
    }
}
