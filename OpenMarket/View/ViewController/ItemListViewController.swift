//
//  OpenMarket - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

@available(iOS 14.0, *)
class ItemListViewController: UIViewController {
    
    private var layoutType = LayoutType.list
    lazy var rightNvigationItem: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(movePostScreen), for: .touchDown)
        return button
    }()
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var control: UISegmentedControl!
    @IBAction func didChangeSegement(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            layoutType = LayoutType.list
            collectionView.reloadData()
            return
        }
        layoutType = LayoutType.grid
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSegmentedControl()
        setUpCollectionView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNvigationItem)
    }
    
    @objc func movePostScreen() {
        guard let ItemPostViewController = self.storyboard?.instantiateViewController(identifier: ItemPostViewController.storyboardID) as? ItemPostViewController else {
            return
        }
        ItemPostViewController.screenMode = ScreenMode.register
        navigationController?.pushViewController(ItemPostViewController, animated: true)
    }
    
    private func setUpCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        registerCollectionViewCellNib()
    }
    
    private func registerCollectionViewCellNib() {
        let listCollectionViewNib = UINib(nibName: ListCollectionViewCell.identifier, bundle: nil)
        let gridCollectionViewNib = UINib(nibName: GridCollectionViewCell.identifier, bundle: nil)
        self.collectionView.register(listCollectionViewNib, forCellWithReuseIdentifier: ListCollectionViewCell.identifier)
        self.collectionView.register(gridCollectionViewNib, forCellWithReuseIdentifier: GridCollectionViewCell.identifier)
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

@available(iOS 14.0, *)
extension ItemListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Cache.shared.itemDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if layoutType == LayoutType.grid {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as? GridCollectionViewCell else  {
                return UICollectionViewCell()
            }
            
            cell.representedIdentifier = indexPath
            guard Cache.shared.itemDataList.count > indexPath.item else { return cell}
            let data = Cache.shared.itemDataList[indexPath.item]
            
            if indexPath == cell.representedIdentifier {
                cell.configure(with: data, itemIndexPath: indexPath.item)
            }
            
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath) as? ListCollectionViewCell else  {
                return UICollectionViewCell()
            }
            cell.representedIdentifier = indexPath
            cell.accessories = [.disclosureIndicator()]
            guard Cache.shared.itemDataList.count > indexPath.item else { return cell}
            let data = Cache.shared.itemDataList[indexPath.item]
            if indexPath == cell.representedIdentifier {
                cell.configure(with: data, itemIndexPath: indexPath.item)
            }

            return cell
        }
    }
    
    private func isThereItemInItems(items: [Item]) -> Bool {
        guard items.count != 0 else {
            DispatchQueue.main.async {
                IndicatorView.shared.dismiss()
            }
            return false
        }
        return true
    }
    
    private func cacheThumbnailImageData(items: [Item]) -> [Data] {
        var thumbnailImageDataList: [Data] = []
        for item in items {
            do {
                guard let imageURL = URL(string: item.thumbnails[0]) else { return [] }
                let imageData = try Data(contentsOf: imageURL)
                thumbnailImageDataList.append(imageData)
            } catch {
                print("cacheThumbnailImageData Invalid URL")
                return []
            }
        }
        return thumbnailImageDataList
    }
    
    private func updateItemDataList(itemDataList: [Item], thumbnailImageDataList: [Data]) {
        if Cache.shared.recentUpdatedItemDataCountOfItemDataList > 0, Cache.shared.recentUpdatedItemDataCountOfItemDataList < 20 {
            for _ in 1...Cache.shared.recentUpdatedItemDataCountOfItemDataList {
                Cache.shared.itemDataList.removeLast()
                Cache.shared.thumbnailImageDataList.removeLast()
            }
        }
        Cache.shared.thumbnailImageDataList += thumbnailImageDataList
        Cache.shared.itemDataList += itemDataList
        Cache.shared.recentUpdatedItemDataCountOfItemDataList = itemDataList.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        var pageNumber = Cache.shared.maxPageNumber + 1
        
        if offsetY > contentHeight - scrollView.frame.height {
            if Cache.shared.recentUpdatedItemDataCountOfItemDataList < 20, Cache.shared.maxPageNumber != 0  {
                pageNumber = Cache.shared.maxPageNumber
            }
           
            guard !NetworkManager.shared.isPaginating else { return }
            
            IndicatorView.shared.showIndicator()
            NetworkManager.shared.getItemsOfPageData(pagination: true, pageNumber: pageNumber) { [weak self] data, pageNumber in
                do {
                    let data = try JSONDecoder().decode(ItemsOfPageReponse.self, from: data!)
                    guard self?.isThereItemInItems(items: data.items) == true else { return }
                    guard let thumbnailImageDataList = self?.cacheThumbnailImageData(items: data.items) else { return }
                    guard let pageNumber = pageNumber else { return }
                    self?.updatePageNumber(pageNumber: pageNumber)
                    DispatchQueue.main.async {
                        self?.updateItemDataList(itemDataList: data.items, thumbnailImageDataList: thumbnailImageDataList)
                        self?.collectionView.reloadData()
                        IndicatorView.shared.dismiss()
                    }
                } catch {
                    fatalError("Failed to decode")
                }
            }
            
        }
        
    }
    
    private func updatePageNumber(pageNumber: Int) {
        Cache.shared.maxPageNumber = max(pageNumber, Cache.shared.maxPageNumber)
        Cache.shared.minPageNumber = min(pageNumber, Cache.shared.minPageNumber)
    }
    
}

@available(iOS 14.0, *)
extension ItemListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard Cache.shared.itemDataList.count > indexPath.item else { return }
        let itemId = Cache.shared.itemDataList[indexPath.item].id
        guard let DetailItemViewController = self.storyboard?.instantiateViewController(identifier: DetailItemViewController.storyboardID) as? DetailItemViewController else { return }
        
        NetworkManager.shared.getDetailItemData(itemId: itemId) { data in
            do {
                guard let responsedData = data else { return }
                DetailItemViewController.detailItemData = try JSONDecoder().decode(InformationOfItemResponse.self, from: responsedData)
            } catch {
                print("Failed to decode")
            }
        }
        DetailItemViewController.itemIndexPath = indexPath.item
        DetailItemViewController.itemListCollectionView = self.collectionView
        navigationController?.pushViewController(DetailItemViewController, animated: true)
    }
}

@available(iOS 14.0, *)
extension ItemListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if layoutType == LayoutType.list {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/10)
        }

        return CGSize(width: collectionView.frame.width/2-20, height: collectionView.frame.height/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }

    func removeStrikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }

}


