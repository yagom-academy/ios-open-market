//
//  OpenMarket - ViewController.swift
//  Created by Kiwi, Hugh. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate {
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    let segment = UISegmentedControl(items: ["List", "Grid"])
    var listCollectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Int> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = "\(item)"
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: listCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<94))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
