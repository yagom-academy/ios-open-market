//
//  OpenMarket - ViewController.swift
//  Created by yagom.
//  Copyright Â© yagom. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: Properties
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, SaleInformation>?
    var snapshot = NSDiffableDataSourceSnapshot<Section, SaleInformation>()
    var count = 1
    
    private var cell = ListCollectionViewCell.identifier
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
        
        let cellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell, SaleInformation> { (cell, indexPath, product) in
            
            guard let url = URL(string: product.thumbnail) else { return }
            guard let imageData = try? Data(contentsOf: url) else { return }
            
            let image = UIImage(data: imageData)
            self.showPrice(priceLabel: cell.productPrice, bargainPriceLabel: cell.productSalePrice, product: product)
            
            cell.productThumnail.image = image
            cell.productName.text = product.name
            cell.productStockQuntity.text = String(product.stock)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, SaleInformation>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, product: SaleInformation) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        }
    }
    
    @objc private func handleSegmentChange() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            collectionView.setCollectionViewLayout(createListLayout(), animated: true)
            cell = ListCollectionViewCell.identifier
            return
        default:
            collectionView.setCollectionViewLayout(createGrideLayout(), animated: true)
            cell = GridCollectionViewCell.identifier
            return
        }
    }
    
    private func showPrice(priceLabel: UILabel, bargainPriceLabel: UILabel, product: SaleInformation) {
        priceLabel.text = "\(product.currency) \(product.price)"
        if product.bargainPrice == 0.0 {
            priceLabel.textColor = .systemGray
            bargainPriceLabel.isHidden = true
        } else {
            priceLabel.textColor = .systemRed
            priceLabel.attributedText = priceLabel.text?.strikeThrough()
            bargainPriceLabel.text = "\(product.currency) \(product.price)"
            bargainPriceLabel.textColor = .systemGray
        }
    }
    
    private func createListLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
    }
    
    private func createGrideLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func setLayout(index: Int) -> UICollectionViewCompositionalLayout {
        var configuration: UICollectionLayoutListConfiguration
        var layout: UICollectionViewCompositionalLayout
        switch index {
        case 0:
            configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            layout = UICollectionViewCompositionalLayout.list(using: configuration)
        default:
            layout = createGrideLayout()
        }
        return layout
    }
    
    private func showNetworkError(message: String) {
        let networkErrorMessage = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default)
        networkErrorMessage.addAction(okButton)
        
        present(networkErrorMessage, animated: true)
    }
}
