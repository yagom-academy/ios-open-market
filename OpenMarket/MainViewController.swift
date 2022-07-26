//
//  OpenMarket - ViewController.swift
//  Created by yagom.
//  Copyright Â© yagom. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    
    private enum Section {
        case main
    }
    
    // MARK: Properties
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let lodingview = UIActivityIndicatorView()
        lodingview.center = self.view.center
        lodingview.startAnimating()
        lodingview.style = UIActivityIndicatorView.Style.large
        lodingview.isHidden = false
        return lodingview
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, SaleInformation>?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, SaleInformation>()
    private var count = 1
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: [CollectionViewNamespace.list.name, CollectionViewNamespace.grid.name])
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentTintColor = .systemBlue
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.link], for: UIControl.State.normal)
        segment.layer.borderColor = UIColor.systemBlue.cgColor
        segment.layer.borderWidth = 1
        return segment
    }()
    
    private let addedButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        let image = UIImage(systemName: CollectionViewNamespace.plus.name, withConfiguration: configuration)
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
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        configureDataSource()
        self.snapshot.appendSections([.main])
        getProductList(pageNumber: 1, itemPerPage: 20)
    }
    
    // MARK: Method
    
    private func setUI() {
        view.addSubview(wholeComponentStackView)
        view.addSubview(loadingView)
        
        setStackView()
        setConstraint()
    }
    
    private func setStackView() {
        wholeComponentStackView.addArrangedSubview(topStackView)
        wholeComponentStackView.addArrangedSubview(collectionView)
        
        topStackView.addArrangedSubview(segmentedControl)
        topStackView.addArrangedSubview(addedButton)
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            wholeComponentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            wholeComponentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            wholeComponentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            wholeComponentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
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
                
                DispatchQueue.main.async {
                    self.dataSource?.apply(self.snapshot, animatingDifferences: false)
                    self.loadingView.stopAnimating()
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
    
    private func configureDataSource() {
            let listCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell, SaleInformation> { (cell, indexPath, product) in
                cell.configureCell(product: product)
            }
            
            let gridCellRegistration = UICollectionView.CellRegistration<GridCollectionViewCell, SaleInformation> { (cell, indexPath, product) in
                cell.configureCell(product: product)
            }
            
            dataSource = UICollectionViewDiffableDataSource<Section, SaleInformation>(
                collectionView: collectionView
            ) { [weak self] collectionView, indexPath, itemIdentifier in
                guard let self = self else { return UICollectionViewCell() }
                switch self.segmentedControl.selectedSegmentIndex {
                case 0:
                    return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: itemIdentifier)
                default:
                    return collectionView.dequeueConfiguredReusableCell(using: gridCellRegistration, for: indexPath, item: itemIdentifier)
                }
            }
        }
    
    @objc private func handleSegmentChange() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            collectionView.setCollectionViewLayout(createListLayout(), animated: true)
            configureDataSource()
            dataSource?.apply(snapshot, animatingDifferences: false)
            return
        default:
            collectionView.setCollectionViewLayout(createGridLayout(), animated: true)
            configureDataSource()
            dataSource?.apply(snapshot, animatingDifferences: false)
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.42))
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
