//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var openMarketCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registCell()
        openMarketCollectionView.dataSource = self
    }
    
    private func registCell() {
        openMarketCollectionView.register(UINib(nibName: "ListCell", bundle: nil), forCellWithReuseIdentifier: "ListCell")
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as? ListCell else { return ListCell() }
        
        return listCell
    }
    
    
}

