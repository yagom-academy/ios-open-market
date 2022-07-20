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
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Page>! = nil
    var snapshot = NSDiffableDataSourceSnapshot<Section, Page>()
    var listCollectionView: UICollectionView! = nil
    let segment = UISegmentedControl(items: ["List", "Grid"])
    let manager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getItemList()
        self.view.backgroundColor = .white
        self.navigationItem.titleView = segment
        configureSegment()
        configureHierarchy()
        configureDataSource()
    }
}


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
            listCollectionView.isHidden = false
        case 1:
            listCollectionView.isHidden = true
        default:
            break
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
    
    private func configureHierarchy() {
        listCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        listCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(listCollectionView)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell, Page> { (cell, indexPath, item) in
            cell.titleLabel.text = "\(item.name)"
            cell.stockLabel.text = "잔여수량: \(item.stock)"
            cell.priceLabel.text = "\(item.currency) \(item.price)"
            
            guard let url = URL(string: item.thumbnail),
                  let imageData = try? Data(contentsOf: url) else { return }
            cell.thumbnailView.image = UIImage(data: imageData)
                    }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Page>(collectionView: listCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Page) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    private func getItemList() {
        manager.getItemList(pageNumber: 1, itemsPerPage: 10) { [self] result in
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
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
