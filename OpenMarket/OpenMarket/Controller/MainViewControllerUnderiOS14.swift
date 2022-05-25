//
//  MainViewControllerUnderiOS14.swift
//  OpenMarket
//
//  Created by papri, Tiana on 24/05/2022.
//

import UIKit

class MainViewControllerUnderiOS14: UIViewController {
    enum Section {
        case main
    }
    
    private let dataProvider = DataProvider()
    private var products: [Product] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    private var collectionView: UICollectionView?
    private var baseView = BaseView()
    private var listLayout: UICollectionViewLayout?
    private var gridLayout: UICollectionViewLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItem()
        applyListLayout()
        applyGridLayout()
        configureHierarchy(collectionViewLayout: listLayout ?? UICollectionViewLayout())
        setUpCollectionView()
        
        dataProvider.fetchData() { products in
            self.products.append(contentsOf: products)
        }
    }
}

extension MainViewControllerUnderiOS14 {
    private func setUpCollectionView() {
        collectionView?.register(ProductListCell.self, forCellWithReuseIdentifier: "ProductListCell")
        collectionView?.register(ProductGridCell.self, forCellWithReuseIdentifier: "ProductGridCell")
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.backgroundColor = .systemBackground
    }
    
    private func setUpNavigationItem() {
        setUpSegmentation()
        navigationItem.titleView = baseView.segmentedControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(touchUpRegisterProduct))
    }
    
    private func setUpSegmentation() {
        baseView.segmentedControl.setWidth(view.bounds.width * 0.18 , forSegmentAt: 0)
        baseView.segmentedControl.setWidth(view.bounds.width * 0.18, forSegmentAt: 1)
        baseView.segmentedControl.addTarget(self, action: #selector(switchCollectionViewLayout), for: .valueChanged)
    }
    
    @objc private func touchUpRegisterProduct() {
        let registerProductView = RegisterProductViewController()
        let navigationController = UINavigationController(rootViewController: registerProductView)
        navigationController.modalTransitionStyle = .coverVertical
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc private func switchCollectionViewLayout() {
        switch baseView.segmentedControl.selectedSegmentIndex {
        case 0:
            guard let listLayout = listLayout else {
                return
            }
            collectionView?.setCollectionViewLayout(listLayout, animated: false)
            collectionView?.reloadData()
        case 1:
            guard let gridLayout = gridLayout else {
                return
            }
            collectionView?.setCollectionViewLayout(gridLayout, animated: false)
            collectionView?.reloadData()
        default:
            break
        }
    }
}

extension MainViewControllerUnderiOS14 {
    private func configureHierarchy(collectionViewLayout: UICollectionViewLayout) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout ?? collectionViewLayout)
        view.addSubview(collectionView ?? UICollectionView())
        layoutCollectionView()
    }
    
    private func applyGridLayout() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        gridLayout = layout
    }
    
    private func applyListLayout() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        listLayout = layout
    }
    
    private func layoutCollectionView() {
        guard let collectionView = collectionView else {
            return
        }
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension MainViewControllerUnderiOS14: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if baseView.segmentedControl.selectedSegmentIndex == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCell", for: indexPath) as? ProductListCell else {
                return UICollectionViewCell()
            }
            
            guard let product = products[safe: indexPath.row] else {
                return UICollectionViewCell()
            }
            
            cell.update(newItem: product)
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductGridCell", for: indexPath) as? ProductGridCell else {
                return UICollectionViewCell()
            }
            
            guard let product = products[safe: indexPath.row] else {
                return UICollectionViewCell()
            }
            
            cell.update(newItem: product)
            return cell
        }
    }
}

extension MainViewControllerUnderiOS14: UICollectionViewDelegate {
    func collectionView( _ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let _ = products[safe: indexPath.row + 1] else {
            dataProvider.fetchData { products in
                self.products.append(contentsOf: products)
            }
            return
        }
    }
}
