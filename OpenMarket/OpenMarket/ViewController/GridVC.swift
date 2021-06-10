//
//  GridVC.swift
//  OpenMarket
//
//  Created by 기원우 on 2021/05/14.
//

import UIKit

class GridVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(Self.setupItems(_:)), name: NotificationNames.items.notificaion, object: nil)
        
    }
    
    @objc func setupItems(_ notification: Notification) {
        if let receiveItems = notification.object as? [Item] {
            self.items = receiveItems
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension GridVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GridVCCell.self), for: indexPath) as! GridVCCell
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 10.0
        
        cell.setup()
        
        if self.items.count > 0 {
            cell.item = items[indexPath.row]
            cell.setupItem()
        }
        return cell
    }
}



