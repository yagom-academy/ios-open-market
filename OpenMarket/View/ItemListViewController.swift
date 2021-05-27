//
//  OpenMarket - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

@available(iOS 14.0, *)
class ItemListViewController: UIViewController {
    
    
    var layoutType = LayoutType.list
 
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
        return Cache.shared.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pageIndex = indexPath.item / 20 + 1
        let itemIndex = indexPath.item % 20
        
        if layoutType == LayoutType.grid {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as? GridCollectionViewCell else  {
                return UICollectionViewCell()
            }
            
            cell.representedIdentifier = indexPath
            guard let _ = Cache.shared.pageDataList[pageIndex] else { return cell }
            guard let data = Cache.shared.pageDataList[pageIndex]?.items[itemIndex] else { return cell }
            
            DispatchQueue.global().async {
                do {
                    guard let imageURL = URL(string: data.thumbnails[0]) else { return }
                    let imageData = try Data(contentsOf: imageURL)
                    DispatchQueue.main.async{
                        if indexPath == cell.representedIdentifier {
                            cell.itemImage.image = UIImage(data: imageData)
                            cell.configure(with: data)
                        }
                    }
                } catch {
                    print("Invalid URL")
                    return
                }
            }
            
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath) as? ListCollectionViewCell else  {
                return UICollectionViewCell()
            }
            cell.representedIdentifier = indexPath
            cell.accessories = [.disclosureIndicator()]
            guard let _ = Cache.shared.pageDataList[pageIndex] else { return cell }
            guard let data = Cache.shared.pageDataList[pageIndex]?.items[itemIndex] else { return cell }
            
            DispatchQueue.global().async {
                do {
                    guard let imageURL = URL(string: data.thumbnails[0]) else { return }
                    let imageData = try Data(contentsOf: imageURL)
                    DispatchQueue.main.async{
                        if indexPath == cell.representedIdentifier {
                            cell.itemImage.image = UIImage(data: imageData)
                            cell.configure(with: data)
                        }
                    }
                } catch {
                    print("Invalid URL")
                    return
                }
            }

            return cell
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        var pageNumber = Cache.shared.maxPageNumber + 1
        
        if offsetY > contentHeight - scrollView.frame.height {
            if let itemCount = Cache.shared.pageDataList[Cache.shared.maxPageNumber]?.items.count, itemCount < 20 {
                pageNumber = Cache.shared.maxPageNumber
            }
            print("page : ",Cache.shared.pageDataList.count)
            print("count : ",Cache.shared.pageDataList[Cache.shared.maxPageNumber]?.items.count)
            guard !NetworkManager.shared.isPaginating else { return }
            
            IndicatorView.shared.showIndicator()
            NetworkManager.shared.getItemsOfPageData(pagination: true, pageNumber: pageNumber) { [weak self] data, pageNumber in
                do {
                    let data = try JSONDecoder().decode(ItemsOfPageReponse.self, from: data!)
                    guard data.items.count != 0 else {
                        DispatchQueue.main.async {
                            IndicatorView.shared.dismiss()
                        }
                        return
                    }
                    guard let pageNumber = pageNumber else { return }
                    Cache.shared.pageDataList[pageNumber] = data
                    Cache.shared.numberOfItems = (Cache.shared.pageDataList.count-1) * 20 + (Cache.shared.pageDataList[pageNumber]?.items.count ?? 0)
                    self?.updatePageNumber(pageNumber: pageNumber)
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                        IndicatorView.shared.dismiss()
                    }
                } catch {
                    fatalError("Failed to decode")
                }
            }
            
        }
        
    }
    
    func updatePageNumber(pageNumber: Int) {
        Cache.shared.maxPageNumber = max(pageNumber, Cache.shared.maxPageNumber)
        Cache.shared.minPageNumber = min(pageNumber, Cache.shared.minPageNumber)
    }
    
}

@available(iOS 14.0, *)
extension ItemListViewController: UICollectionViewDelegate {
    
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


