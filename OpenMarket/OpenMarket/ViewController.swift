//
//  OpenMarket - ViewController.swift
//  Created by Grumpy, OneTool
//  Copyright © yagom. All rights reserved.
// 

import UIKit

enum ArrangeMode: Int {
    case list = 0
    case grid = 1
}

class ViewController: UIViewController {
    var arrangeMode: ArrangeMode = .list
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout())
    let segmentedControl = UISegmentedControl(items: ["List", "Grid"])
    
    private let data: [Product] = {
        let parser: Parser<ProductList> = Parser()
        let sampleList: ProductList = parser.decode(name: "products")!
        return sampleList.pages
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(segmentedControl)
        self.view.addSubview(collectionView)
        segmentLayout()
        configureCollectionView()
        collectionViewDelegate()
        
        segmentedControl.addTarget(self, action: #selector(arrangementChange(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        self.arrangementChange(segmentedControl)
    }
    
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = true
        listConfiguration.backgroundColor = UIColor.clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func gridLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(self.view.frame.height * 0.35))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = CGFloat(10)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func segmentLayout() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    @objc func arrangementChange(_ sender: UISegmentedControl) {
        let mode = sender.selectedSegmentIndex
        
        if mode == ArrangeMode.list.rawValue {
            self.arrangeMode = .list
            collectionView.setCollectionViewLayout(listLayout(), animated: true)
            collectionView
                .register(ListCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "listCell")
            self.collectionView.reloadData()
        } else if mode == ArrangeMode.grid.rawValue {
            self.arrangeMode = .grid
            collectionView.setCollectionViewLayout(gridLayout(), animated: true)
            collectionView
                .register(GridCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "gridCell")
            self.collectionView.reloadData()
        }
    }
    
    func configureCollectionView() {
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

extension ViewController {
    
    func collectionViewDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.arrangeMode {
        case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as? ListCollectionViewCell else { return UICollectionViewCell() }
            cell.productNameLabel.text = data[indexPath.row].name
            cell.productPriceLabel.text = String(data[indexPath.row].price)
            cell.productStockLabel.text = String(data[indexPath.row].stock)
            return cell
        case .grid:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as? GridCollectionViewCell else { return UICollectionViewCell() }
            cell.productNameLabel.text = data[indexPath.row].name
            cell.productPriceLabel.text = String(data[indexPath.row].price)
            cell.productStockLabel.text = String(data[indexPath.row].stock)
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.systemPink.cgColor
            return cell
        }
    }
}

