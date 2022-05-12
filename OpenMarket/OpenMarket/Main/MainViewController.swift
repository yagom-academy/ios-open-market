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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidTapped))
        
        let segmentControl = UISegmentedControl(items: ["LIST", "GRID"])
        segmentControl.selectedSegmentTintColor = .systemBlue
        segmentControl.addTarget(self, action: #selector(segmentValueDidChanged(segmentedControl:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        navigationItem.titleView = segmentControl
    }
    
    @objc private func addButtonDidTapped() {}
    
    @objc private func segmentValueDidChanged(segmentedControl: UISegmentedControl) {}
    
    private func configureView() {
        mainView.backgroundColor = .systemBackground
        self.view = mainView
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else {
            return ProductCell()
        }
        
        cell.configure(data: dummyList?[indexPath.item])
        
        return cell
    }
}
