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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(Self.setupItems(_:)), name: NotificationNames.items.notificaion, object: nil)
        
        let flowLayout: UICollectionViewFlowLayout
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        
        let halfWidth: CGFloat = UIScreen.main.bounds.width / 2.0
        flowLayout.itemSize = CGSize(width: halfWidth - 30, height: 350)
        
        self.collectionView.collectionViewLayout = flowLayout
        super.viewDidLoad()
        print("viewDidLoad")
    }
    
    @objc func setupItems(_ notification: Notification) {
        if let receiveItems = notification.object as? [Item] {
            self.items = receiveItems
            
            print("success CollectionView nofitication")
            
            DispatchQueue.main.async {
                print("success CollectionView reloadData")
                self.collectionView.reloadData()
            }
        }
    }

    
}


extension GridVC: UICollectionViewDelegate {

    
}

extension GridVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//            let itemSpacing: CGFloat = 10 // 가로에서 cell과 cell 사이의 거리
//            let textAreaHeight: CGFloat = 65 // textLabel이 차지하는 높이
//            let width: CGFloat = (collectionView.bounds.width - itemSpacing)/2 // 셀 하나의 너비
//            let height: CGFloat = width * 10/7 + textAreaHeight //셀 하나의 높이
//
//            return CGSize(width: width, height: height)
//        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridVCCell", for: indexPath) as! GridVCCell
        
        cell.setup()

        if self.items.count > 0 {
            cell.item = items[indexPath.row]
            cell.setupItem()
        }
        
        return cell
    }
    
}
    
    
