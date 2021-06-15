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
        
        let myCustomCollectionViewCellNib = UINib(nibName: String(describing: GridCollectionViewCell.self), bundle: nil)
        
       
        self.collectionView.register(myCustomCollectionViewCellNib, forCellWithReuseIdentifier: String(describing: GridCollectionViewCell.self))
        
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
        print("createCompositionalLayoutForSecond() called")
        // 콤포지셔널 레이아웃 생성
        let layout = UICollectionViewCompositionalLayout{
            // 만들게 되면 튜플 (키: 값, 키: 값) 의 묶음으로 들어옴 반환 하는 것은 NSCollectionLayoutSection 콜렉션 레이아웃 섹션을 반환해야함
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            // 아이템에 대한 사이즈 - absolute 는 고정값, estimated 는 추측, fraction 퍼센트
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            
            // 위에서 만든 아이템 사이즈로 아이템 만들기
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // 아이템 간의 간격 설정
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // 변경할 부분
            let groupHeight =  NSCollectionLayoutDimension.fractionalWidth(1/2)
            
            // 그룹사이즈
            let grouSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
            
            // 그룹사이즈로 그룹 만들기
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: grouSize, subitems: [item, item, item])
            
            // 변경할 부분
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: grouSize, subitem: item, count: 2)
            
            // 그룹으로 섹션 만들기
            let section = NSCollectionLayoutSection(group: group)
//            section.orthogonalScrollingBehavior = .groupPaging
            
            // 섹션에 대한 간격 설정
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GridCollectionViewCell.self), for: indexPath) as! GridCollectionViewCell
        
        cell.setup()

        cell.item = items[indexPath.row]
        cell.setupItem()

        return cell
    }
}



