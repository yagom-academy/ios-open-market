//
//  ViewController.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/14.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var currentCollectionView: UICollectionView?
    
    let listCollectionView: UICollectionView
    let gridCollectionView: UICollectionView
    let listDataSource: UICollectionViewDiffableDataSource<Int, Product>
    let gridDataSource: UICollectionViewDiffableDataSource<Int, Product>
    
    required init?(coder: NSCoder) {
        self.listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: OpenMarketLayout.list.layout)
        self.gridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: OpenMarketLayout.grid.layout)
        self.gridDataSource = OpenMarketLayout.grid.createDataSource(for: gridCollectionView)
        self.listDataSource = OpenMarketLayout.list.createDataSource(for: listCollectionView)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewLayout()
        
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        configureViewLayout()
        
    }
}

extension ViewController {
    
    func configureViewLayout() {
        if currentCollectionView != nil {
            currentCollectionView?.removeFromSuperview()
        }
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            currentCollectionView = listCollectionView
        default:
            currentCollectionView = gridCollectionView
        }
        
        guard let collectionView = currentCollectionView else { return }
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }
    
}
