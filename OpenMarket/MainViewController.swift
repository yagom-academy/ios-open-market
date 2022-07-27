//
//  OpenMarket - ViewController.swift
//  Created by yagom.
//  Copyright Â© yagom. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    
    enum Section {
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
        segment.selectedSegmentIndex = Metric.firstSegment
        segment.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentTintColor = .systemBlue
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.link], for: UIControl.State.normal)
        segment.layer.borderColor = UIColor.systemBlue.cgColor
        segment.layer.borderWidth = Metric.borderWidth
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
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: "list")
        collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: "grid")
        dataSource = configureDataSource(id: "list")
        self.snapshot.appendSections([.main])
        getProductList(pageNumber: Metric.firstPage, itemPerPage: Metric.itemCount)
    }
    
    // MARK: Method
    
    private func setUI() {
        view.translatesAutoresizingMaskIntoConstraints = false
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
                self.dataSource?.apply(self.snapshot, animatingDifferences: false)
                
                DispatchQueue.main.async {
                    self.loadingView.stopAnimating()
                }
                
                DispatchQueue.global().async {
                    let next = productList.lastPage
                    if self.count < next {
                        self.getProductList(pageNumber: self.count, itemPerPage: Metric.itemCount)
                        self.count += 1
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showNetworkError(message: error.localizedDescription)
                }
            }
        }
    }
    
    func configureDataSource(id: String) -> UICollectionViewDiffableDataSource<Section, SaleInformation>? {
        dataSource = UICollectionViewDiffableDataSource<Section, SaleInformation>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, product: SaleInformation) -> UICollectionViewCell? in
            
            switch id {
            case "list":
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "list", for: indexPath) as? ListCollectionViewCell else {
                    fatalError("")
                }
                cell.configureCell(product: product)
                return cell
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "grid", for: indexPath) as? GridCollectionViewCell else {
                    fatalError("")
                }
                cell.configureCell(product: product)
                return cell
            }
        }
        return dataSource
    }
    
    @objc private func handleSegmentChange() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            collectionView.setCollectionViewLayout(createListLayout(), animated: true)
            dataSource = configureDataSource(id: "list")
            dataSource?.apply(snapshot, animatingDifferences: false)
            return
        default:
            collectionView.setCollectionViewLayout(createGridLayout(), animated: true)
            dataSource = configureDataSource(id: "grid")
            dataSource?.apply(snapshot, animatingDifferences: false)
            return
        }
    }
    
    private func createListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Metric.listItemWidth), heightDimension: .fractionalHeight(Metric.listItemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Metric.listGroupWidth), heightDimension: .fractionalHeight(Metric.listGroupHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: Metric.listGroupCount)
        group.contentInsets = NSDirectionalEdgeInsets(top: Metric.padding, leading: Metric.padding, bottom: Metric.padding, trailing: .zero)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Metric.listGroupSpacing
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func createGridLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Metric.gridItemWidth), heightDimension: .fractionalHeight(Metric.gridItemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Metric.gridGroupWidth), heightDimension: .fractionalHeight(Metric.gridGroupHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: Metric.gridGroupCount)
        group.interItemSpacing = .fixed(Metric.gridGroupSpacing)
        group.contentInsets = NSDirectionalEdgeInsets(top: Metric.padding, leading: Metric.padding, bottom: Metric.padding, trailing: Metric.padding)
        
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
