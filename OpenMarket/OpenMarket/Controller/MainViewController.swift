//
//  OpenMarket - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

private enum Section: Int {
    case main
}

private struct Product: APIable {
    var hostAPI: String = "https://market-training.yagom-academy.kr"
    var path: String = "/api/products"
    var param: [String : String]? = [
        "page_no": "1",
        "items_per_page": "10"
    ]
    var method: HTTPMethod = .get
}

final class MainViewController: UIViewController {
    fileprivate typealias DataSource = UICollectionViewDiffableDataSource<Section, Products>
    fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Products>
    
    private lazy var dataSource = makeDataSource()
    private let product = Product()
    private lazy var productView = ProductListView.init(frame: view.bounds)
    private lazy var plusButton: UIBarButtonItem = {
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonDidTapped(_:)))
        
        return plusButton
    }()
    
    private let networkManager = NetworkManager<ProductsList>(session: URLSession.shared)
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
        executeAPI()
        applySnapshot()
    }
}

// MARK: - setup UI
extension MainViewController {
    private func configureView() {
        self.view = productView
        view.backgroundColor = .white
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
    private func executeAPI() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        DispatchQueue.global().async(group: dispatchGroup) {
            self.networkManager.execute(with: self.product) { result in
                switch result {
                case .success(let result):
                    self.item = result.pages
                    dispatchGroup.leave()
                case .failure(let error):
                    print(error.localizedDescription)
                }
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
                var presenter = Presenter()
                presenter = presenter.setData(of: product)

                guard let layoutType = LayoutType(rawValue: self.productView.segmentedControl.selectedSegmentIndex) else { return UICollectionViewCell() }
                
                switch layoutType {
                case .list:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath) as? ListCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    
                    
                    cell.configureCell(presenter)
                    
                    return cell
                    
                case .grid:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as? GridCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    
                    cell.configureCell(presenter)
                    
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
