//
//  OpenMarket - ViewController.swift
//  Created by Kiwi, Hugh. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var listDataSource: UICollectionViewDiffableDataSource<Section, Page>! = nil
    var gridDataSource: UICollectionViewDiffableDataSource<Section, Page>! = nil
    var snapshot = NSDiffableDataSourceSnapshot<Section, Page>()
    var collectionView: UICollectionView! = nil
    let segment = UISegmentedControl(items: ["List", "Grid"])
    let manager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getItemList()
        self.view.backgroundColor = .white
        self.navigationItem.titleView = segment
        configureSegment()
        configureGridHierarchy()
        configureGridDataSource()
        configureListHierarchy()
        configureListDataSource()
        
    }
    
    private func getItemList() {
        manager.getItemList(pageNumber: 1, itemsPerPage: 100) { [self] result in
            switch result {
            case .success(let data):
                guard let data = data,
                      let itemData: ItemList = JSONDecoder.decodeJson(jsonData: data) else { return }
                
                makeSnapshot(itemData: itemData)
            case .failure(ResponseError.dataError):
                return
            case .failure(ResponseError.defaultResponseError):
                return
            case .failure(ResponseError.statusError):
                return
            }
        }
    }
    
    private func makeSnapshot(itemData: ItemList) {
        snapshot.appendSections([.main])
        snapshot.appendItems(itemData.pages)
        listDataSource.apply(snapshot, animatingDifferences: false)
        gridDataSource.apply(snapshot, animatingDifferences: false)
    }
}

//MARK: Segment
extension MainViewController {
    private func configureSegment() {
        segment.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
        segment.setTitleTextAttributes([.foregroundColor : UIColor.systemBlue], for: .normal)
        segment.selectedSegmentTintColor = .systemBlue
        segment.frame.size.width = view.bounds.width * 0.4
        segment.setWidth(view.bounds.width * 0.2, forSegmentAt: 0)
        segment.setWidth(view.bounds.width * 0.2, forSegmentAt: 1)
        segment.layer.borderWidth = 1.0
        segment.layer.borderColor = UIColor.systemBlue.cgColor
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(tapSegment), for: .valueChanged)
    }
    
    @objc private func tapSegment(sender: UISegmentedControl) {
        let selection = sender.selectedSegmentIndex
        switch selection {
        case 0:
            collectionView.dataSource = listDataSource
            collectionView.setCollectionViewLayout(createListLayout(), animated: true)
        case 1:
            collectionView.dataSource = gridDataSource
            collectionView.setCollectionViewLayout(createGridLayout(), animated: true)
        default:
            break
        }
    }
}
//MARK: ListCollectionView
extension MainViewController {
    private func createListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureListHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createListLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    private func configureListDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell, Page> { (cell, indexPath, item) in
            cell.titleLabel.text = "\(item.name)"
            cell.stockLabel.text = "잔여수량: \(item.stock)"
            cell.stockLabel.textColor = .systemGray
            cell.priceLabel.text = "\(item.currency) \(item.price)"
            cell.priceLabel.textColor = .systemGray
            
            if item.price > item.discountedPrice {
                cell.discountedLabel.isHidden = false
                cell.discountedLabel.text = "\(item.currency) \(item.discountedPrice)"
                cell.priceLabel.textColor = .systemRed
                cell.layer.borderColor = UIColor.systemGray.cgColor
                cell.layer.borderWidth = 0.2
                
                guard let priceText = cell.priceLabel.text else { return }
                let attribute = NSMutableAttributedString(string: priceText)
                attribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attribute.length))
                cell.priceLabel.attributedText = attribute
                cell.discountedLabel.textColor = .systemGray
            }
            
            if item.stock == 0 {
                cell.stockLabel.text = "품절"
                cell.stockLabel.textColor = .systemYellow
            }
            
            guard let url = URL(string: item.thumbnail),
                  let imageData = try? Data(contentsOf: url) else { return }
            cell.thumbnailView.image = UIImage(data: imageData)
        }
        
        listDataSource = UICollectionViewDiffableDataSource<Section, Page>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Page) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
}
//MARK: GridCollectionView

extension MainViewController {
    
    func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureGridHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createGridLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    func configureGridDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<GridCollectionViewCell, Page> { (cell, indexPath, item) in
            
            cell.titleLabel.text = "\(item.name)"
            cell.stockLabel.text = "잔여수량: \(item.stock)"
            cell.stockLabel.textColor = .systemGray
            cell.priceLabel.text = "\(item.currency) \(item.price)"
            cell.priceLabel.textColor = .systemGray
            
            if item.price > item.discountedPrice {
                cell.discountedLabel.isHidden = false
                cell.discountedLabel.text = "\(item.currency) \(item.discountedPrice)"
                cell.priceLabel.textColor = .systemRed
                
                guard let priceText = cell.priceLabel.text else { return }
                let attribute = NSMutableAttributedString(string: priceText)
                attribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attribute.length))
                cell.priceLabel.attributedText = attribute
                cell.discountedLabel.textColor = .systemGray
            }
            
            if item.stock == 0 {
                cell.stockLabel.text = "품절"
                cell.stockLabel.textColor = .systemYellow
            }
            
            guard let url = URL(string: item.thumbnail),
                  let imageData = try? Data(contentsOf: url) else { return }
            cell.itemImageView.image = UIImage(data: imageData)
            cell.layer.cornerRadius = 10.0
            cell.layer.borderColor = UIColor.systemGray.cgColor
            cell.layer.borderWidth = 1
        }
        
        gridDataSource = UICollectionViewDiffableDataSource<Section, Page>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Page) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
}
