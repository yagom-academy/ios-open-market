//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ItemListViewController: UIViewController {
    
    var pageDataList: [Int : ItemsOfPageReponse] = [:]
    var reuseCollectionViewIdentifier = ListCollectionViewCell.identifier
    var numberOfItems = 0
    
    let networkManager = NetworkManager.shared
 
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var control: UISegmentedControl!
    @IBAction func didChangeSegement(_ sender: UISegmentedControl) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSegmentedControl()
        setUpCollectionView()
    }
    
    
    private func setUpCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        registerCollectionViewCellNib()
    }
    
    private func registerCollectionViewCellNib() {
        let collectionViewNib = UINib(nibName: reuseCollectionViewIdentifier, bundle: nil)
        self.self.collectionView.register(collectionViewNib, forCellWithReuseIdentifier: reuseCollectionViewIdentifier)
    }

    private func setUpSegmentedControl() {
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue],
                                       for: UIControl.State.normal)
        control.layer.borderWidth = 0.5
        control.layer.borderColor = UIColor.systemBlue.cgColor
        control.backgroundColor = UIColor.white
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white],
                                       for: UIControl.State.selected)
    }
    

}

extension ItemListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var pageIndex = indexPath.item / 20 + 1
        let itemIndex = indexPath.item % 20
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCollectionViewIdentifier, for: indexPath) as? ListCollectionViewCell else  {
            return UICollectionViewCell()
        }
        
        if let _ = self.pageDataList[pageIndex] {
            print("@: \(pageDataList.count)")
            print("using cached data")
            guard let item = self.pageDataList[pageIndex]?.items[itemIndex] else { return cell }
            cell.update(data: item)
            return cell
        }
        
        networkManager.getItemsOfPageData(pagination: false, pageNumber: pageIndex) { [weak self] data in
            do {
                let data = try JSONDecoder().decode(ItemsOfPageReponse.self, from: data!)
                self?.pageDataList[pageIndex] = data
                guard let pageData = self?.pageDataList[pageIndex] else { return }
                let item = pageData.items[itemIndex]
                DispatchQueue.main.async {
                    self?.numberOfItems += self?.pageDataList[pageIndex]?.items.count ?? 0
                    cell.update(data: item)
                    self?.collectionView.reloadData()
                }
            } catch {
                fatalError("Failed to decode")
            }
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            if offsetY > contentHeight - scrollView.frame.height {
                guard !networkManager.isPaginating else {
                    return
                }
                networkManager.getItemsOfPageData(pagination: true, pageNumber: pageDataList.count + 1) { [weak self] data in
                    do {
                        let data = try JSONDecoder().decode(ItemsOfPageReponse.self, from: data!)
                        guard let pageNumber = self?.pageDataList.count else { return }
                        self?.pageDataList[pageNumber + 1] = data
                        DispatchQueue.main.async {
                            
                            print(self?.pageDataList[pageNumber+1]?.items.count)
                            
                            self?.numberOfItems += self?.pageDataList[pageNumber+1]?.items.count ?? 0
                            print("@%@%@%@%@%\(self?.numberOfItems)")
                            self?.collectionView.reloadData()
                        }
                    } catch {
                        fatalError("Failed to decode")
                    }
                }
            }
    }
    
}

extension ItemListViewController: UICollectionViewDelegate {
    
}

extension ItemListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/8)
    }
}




