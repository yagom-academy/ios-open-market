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
        notificationAddObserver()
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let myCustomCollectionViewCellNib = UINib(nibName: String(describing: GridVCCell.self), bundle: nil)
        
        
        self.collectionView.register(myCustomCollectionViewCellNib, forCellWithReuseIdentifier: String(describing: GridVCCell.self))
        
        // 콜렉션뷰의 콜렉션뷰 레이아웃을 설정한다.
        self.collectionView.collectionViewLayout = createCompositionalLayoutForGrid()
    }
    
    func notificationAddObserver() {
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

extension GridVC {
    fileprivate func createCompositionalLayoutForGrid() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
            
            let groupHeight =  NSCollectionLayoutDimension.fractionalWidth(1/2)
            
            let grouSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: grouSize, subitem: item, count: 2)
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            return section
        }
        return layout
    }
}

extension GridVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GridVCCell.self), for: indexPath) as! GridVCCell
        
        cell.setup()
        
        cell.item = items[indexPath.row]
        cell.setupItem()
        
        return cell
    }
}



