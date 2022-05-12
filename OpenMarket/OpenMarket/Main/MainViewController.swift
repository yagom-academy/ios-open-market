//
//  OpenMarket - MainViewController.swift
//  Created by yagom. 
//  Copyright dudu, safari All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    private lazy var mainView = MainView(frame: self.view.bounds)
    
    private let dummyList: [Product]? = {
        guard let path = Bundle.main.path(forResource: "products", ofType: "json") else { return nil }
        guard let jsonString = try? String(contentsOfFile: path) else { return nil }
        guard let data = jsonString.data(using: .utf8) else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SS"
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return try? jsonDecoder.decode(ProductList.self, from: data).products
        
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["LIST", "GRID"])
        segmentControl.selectedSegmentTintColor = .systemBlue
        segmentControl.addTarget(self, action: #selector(segmentValueDidChanged(segmentedControl:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidTapped))
        navigationItem.titleView = segmentControl
    }
    
    @objc private func addButtonDidTapped() {}
    
    @objc private func segmentValueDidChanged(segmentedControl: UISegmentedControl) {
        mainView.changeLayout(index: segmentedControl.selectedSegmentIndex)
        mainView.collectionView.reloadData()
    }
    
    private func configureView() {
        mainView.backgroundColor = .systemBackground
        self.view = mainView
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(ProductGridCell.self, forCellWithReuseIdentifier: ProductGridCell.identifier)
        mainView.collectionView.register(ProductListCell.self, forCellWithReuseIdentifier: ProductListCell.identifier)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let layout = CollectionLayout(rawValue: segmentControl.selectedSegmentIndex) else { return UICollectionViewCell() }
        
        switch layout {
        case .grid:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductGridCell.identifier, for: indexPath) as? ProductGridCell else { return ProductGridCell() }
            cell.configure(data: dummyList?[indexPath.item])
            return cell
        case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCell.identifier, for: indexPath) as? ProductListCell else { return ProductListCell() }
            cell.configure(data: dummyList?[indexPath.item])
            return cell
        }
    }
}
