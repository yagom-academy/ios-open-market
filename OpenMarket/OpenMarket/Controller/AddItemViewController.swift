//
//  EmptyViewController.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/27.
//

import UIKit

final class AddItemViewController: UIViewController {
    let addItemView = AddItemView()
    var productImage: ProductImage?
    var snapshot = NSDiffableDataSourceSnapshot<Section, ProductImage>()
    var imageDataSource: UICollectionViewDiffableDataSource<Section, ProductImage>?
    private let imageCollectionView: UICollectionView = {
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
            collectionView.isScrollEnabled = false
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
    }()
    
    enum Section {
        case main
    }
    
    struct ProductImage: Hashable {
        let image: UIImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationBar()
        configureHierarchy()
        
        configureLayout()
    }
    
    private func configureNavigationBar() {
        self.title = "상품등록"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                                style: .plain,
                                                                target: self, action:
                                                                    #selector(tapped(sender:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(tapped(sender:)))
    }
    
    @objc private func tapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func postImageList() {
        let url = OpenMarketURL.postProductComponent.url
        
        
//        NetworkManager.publicNetworkManager.getJSONData(url: url, type: ItemList.self) { itemData in
//            self.makeSnapshot(itemData: itemData)
//        }
    }
    
    private func makeSnapshot(itemData: ItemList) {
        snapshot.appendSections([.main])
        snapshot.appendItems(productImage?.image)
        imageDataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension AddItemViewController {
    func configureLayout() {
        self.view.addSubview(imageCollectionView)
        self.view.addSubview(addItemView)
        
        addItemView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            addItemView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            addItemView.topAnchor.constraint(equalTo: self.imageCollectionView.bottomAnchor, constant: 10),
            addItemView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            addItemView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            imageCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            imageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageCollectionView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6)
        ])
    }
}

extension AddItemViewController {
    private func createImageLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureHierarchy() {
        imageCollectionView.collectionViewLayout = createImageLayout()
        imageCollectionView.dataSource = imageDataSource
//        collectionView?.delegate = self
    }
    
    private func configureListDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ImageCollectionViewCell, ProductImage> { (cell, indexPath, image) in
            cell.contentView.layer.cornerRadius = 2.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.black.cgColor
        }
        
        imageDataSource = UICollectionViewDiffableDataSource<Section, ProductImage>(collectionView: imageCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: ProductImage) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
}
