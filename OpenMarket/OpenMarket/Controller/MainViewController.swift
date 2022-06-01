//
//  OpenMarket - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

private enum Section: Int {
    case main
}

final class MainViewController: UIViewController {
    fileprivate typealias DataSource = UICollectionViewDiffableDataSource<Section, Products>
    fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Products>
    
    private var presenter = Presenter()
    private lazy var dataSource = makeDataSource()
    private var hasNext: Bool = false
    private var pageNo: Int = 1

    private lazy var productView = ProductListView.init(frame: view.bounds)
    private lazy var plusButton: UIBarButtonItem = {
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonDidTapped(_:)))
        
        return plusButton
    }()
    private let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelButtonDidTapped(_:)))
    
    private var networkManager = NetworkManager<ProductsList>(session: URLSession.shared)
    private lazy var item: [Products] = [] {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self.applySnapshot()
                self.productView.indicatorView.stopAnimating()
            })
        }
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productView.indicatorView.startAnimating()
        configureView()
        registerCell()
        applySnapshot()
        productView.collectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.item.removeAll()
        pageNo = 1
        self.executeGET(number: pageNo)
    }
}

// MARK: - setup UI
extension MainViewController {
    private func configureView() {
        self.view = productView
        view.backgroundColor = .white
        self.navigationItem.backBarButtonItem = cancelButton
        setNavigation()
        
        NSLayoutConstraint.activate([
            productView.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            productView.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            productView.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            productView.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        productView.configureLayout()
    }
    
    @objc private func plusButtonDidTapped(_ sender: UIBarButtonItem) {
        let registrationViewController = RegistrationViewController()
        
        self.navigationController?.pushViewController(registrationViewController, animated: true)
    }
    
    @objc private func cancelButtonDidTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setNavigation() {
        navigationItem.titleView = productView.segmentedControl
        navigationItem.rightBarButtonItem = plusButton

        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .systemGray6
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
}

// MARK: - setup DataSource
extension MainViewController {
    private func executeGET(number: Int) {
        self.networkManager.execute(with: .productList(pageNumber: number, itemsPerPage: 20), httpMethod: .get) { result in
            switch result {
            case .success(let result):
                self.hasNext = result.hasNext
                self.pageNo = result.pageNo
                self.item.append(contentsOf: result.pages)
                DispatchQueue.main.async {
                    self.productView.collectionView.reloadData()
                    self.productView.indicatorView.stopAnimating()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func registerCell() {
        productView.collectionView.dataSource = self.dataSource
        productView.collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.identifier)
        productView.collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: GridCollectionViewCell.identifier)
    }

    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: productView.collectionView,
            cellProvider: { (collectionView, indexPath, product) -> UICollectionViewCell? in
                self.setData(product)
                self.setPrice(product)
                self.setStock(product)
                
                guard let layoutType = LayoutType(rawValue: self.productView.segmentedControl.selectedSegmentIndex) else { return UICollectionViewCell() }
                
                switch layoutType {
                case .list:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath) as? ListCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.configureCell(self.presenter)
                    
                    return cell
                    
                case .grid:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as? GridCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.configureCell(self.presenter)
                    
                    return cell
                }
            })
        
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapShot = Snapshot()
        snapShot.appendSections([.main])
        snapShot.appendItems(item)
        dataSource.apply(snapShot, animatingDifferences: animatingDifferences)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailViewController = ProductDetailViewController(products: item[indexPath.row])
        
        self.navigationController?.pushViewController(productDetailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let buffer = 3
        guard indexPath.row == item.count - buffer,
              hasNext == true else {
            return
        }
        
        executeGET(number: pageNo + 1)
    }
}

// MARK: - Set Presenter
extension MainViewController {
    private func setData(_ product: Products) {
        presenter = presenter.setData(of: product)
    }
    
    private func setPrice(_ product: Products) {
        let productCurrency = product.currency ?? ""
        
        let bargainPrice = product.bargainPrice ?? 0
        let price = product.price ?? 0
        
        let formattedBargainPrice = bargainPrice.formatNumber()
        let formattedPrice = price.formatNumber()
        
        presenter.bargainPrice = "\(productCurrency) \(formattedBargainPrice)"
        presenter.price = "\(productCurrency) \(formattedPrice)"
    }
    
    private func setStock(_ product: Products) {
        if presenter.stock == Stock.zero {
            presenter.stock = Stock.soldOut
        } else {
            presenter.stock = "\(Stock.stock) \(presenter.stock ?? "")"
        }
    }
}
