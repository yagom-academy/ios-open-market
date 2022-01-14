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
        
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
    }
}


