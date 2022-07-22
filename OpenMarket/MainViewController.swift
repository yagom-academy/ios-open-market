//
//  OpenMarket - ViewController.swift
//  Created by yagom.
//  Copyright Â© yagom. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    static var viewCell = "LIST"
    //        willSet(cell) {
    //            if cell == "LIST" {
    //            } else {
    //            }
    //        }
    //    }
    // MARK: Properties
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, SaleInformation>?
    var snapshot = NSDiffableDataSourceSnapshot<Section, SaleInformation>()
    var count = 1
    
    private var productsData: MarketInformation?
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["LIST", "GRID"])
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    private let addedButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        let image = UIImage(systemName: "plus", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        let leftCoordinate = (view.frame.width / 2) - (segmentedControl.frame.width / 2)
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.layoutMargins = UIEdgeInsets(top: .zero, left: leftCoordinate, bottom: .zero, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createListLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return collectionView
    }()
    
    private let wholeComponentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(wholeComponentStackView)
        wholeComponentStackView.addArrangedSubview(topStackView)
        wholeComponentStackView.addArrangedSubview(collectionView)
        
        topStackView.addArrangedSubview(segmentedControl)
        topStackView.addArrangedSubview(addedButton)
        
        NSLayoutConstraint.activate([
            wholeComponentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            wholeComponentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            wholeComponentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            wholeComponentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
        
        self.snapshot.appendSections([.main])
        getProductList(pageNumber: 1, itemPerPage: 20)
        configureDataSource()
    }
    
    private func getProductList(pageNumber: Int, itemPerPage: Int) {
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let networkManger = NetworkManager(session: urlSession)
        
        let queryItems = OpenMarketRequest().createQuery(of: String(pageNumber), with: String(itemPerPage))
        let request = OpenMarketRequest().requestProductList(queryItems: queryItems)
        
        networkManger.getProductInquiry(request: request) { result in
            switch result {
            case .success(let data):
                guard let productList = try? JSONDecoder().decode(MarketInformation.self, from: data) else { return }
                
                self.snapshot.appendItems(productList.pages)
                
                DispatchQueue.main.sync {
                    self.dataSource?.apply(self.snapshot, animatingDifferences: false)
                }
                
                DispatchQueue.global().async {
                    let next = productList.lastPage
                    if self.count < next {
                        self.getProductList(pageNumber: self.count, itemPerPage: 20)
                        self.count += 1
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showNetworkError(message: NetworkError.outOfRange.message)
                }
            }
        }
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ItemCollectionViewCell, SaleInformation> { [weak self] (cell, indexPath, product) in
            cell.configureCell(product: product)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, SaleInformation>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, product: SaleInformation) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        }
    }
    
    @objc private func handleSegmentChange() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            MainViewController.viewCell = "LIST"
            collectionView.setCollectionViewLayout(createListLayout(), animated: true)
            return
        default:
            MainViewController.viewCell = "GRID"
            collectionView.setCollectionViewLayout(createGridLayout(), animated: true)
            return
        }
    }
    
    private func createListLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
    }
    
    private func createGridLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.8))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func showNetworkError(message: String) {
        let networkErrorMessage = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default)
        networkErrorMessage.addAction(okButton)
        
        present(networkErrorMessage, animated: true)
    }
}
