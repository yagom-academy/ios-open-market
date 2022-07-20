//
//  OpenMarket - ViewController.swift
//  Created by yagom.
//  Copyright Â© yagom. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: Properties
    
    private var cell = ListCollectionViewCell.identifier
    
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
        
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: cell)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func getProductList(about pageNumber: String, _ itemPerPage: String) {
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let networkManger = NetworkManager(session: urlSession)
        let queryItems = OpenMarketRequest().createQuery(of: pageNumber, with: itemPerPage)
        let request = OpenMarketRequest().requestProductList(queryItems: queryItems)
        
        networkManger.getProductInquiry(request: request) { result in
            switch result {
            case .success(let data):
                guard let productList = try? JSONDecoder().decode(MarketInformation.self, from: data) else { return }
                print(productList)
            case .failure(let error):
                print(error)
            }
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
}

// MARK: Extension
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath)
        return cell
    }
}
