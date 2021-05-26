//
//  OpenMarket - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

@available(iOS 14.0, *)
class ItemListViewController: UIViewController {
    
    var pageDataList: [Int : ItemsOfPageReponse] = [:]
    var reuseCollectionViewIdentifier = ListCollectionViewCell.identifier
    var numberOfItems = 0
    
    let networkManager = NetworkManager.shared
 
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var control: UISegmentedControl!
    @IBAction func didChangeSegement(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            reuseCollectionViewIdentifier = ListCollectionViewCell.identifier
            registerCollectionViewCellNib()
            collectionView.reloadData()
            return
        }
        reuseCollectionViewIdentifier = GridCollectionViewCell.identifier
        registerCollectionViewCellNib()
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

@available(iOS 14.0, *)
extension ItemListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pageIndex = indexPath.item / 20 + 1
        let itemIndex = indexPath.item % 20
        let representedIdentifier = String(describing: indexPath)
        
        if reuseCollectionViewIdentifier == GridCollectionViewCell.identifier {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCollectionViewIdentifier, for: indexPath) as? GridCollectionViewCell else  {
                return UICollectionViewCell()
            }
            
            cell.representedIdentifier = representedIdentifier

            if let _ = self.pageDataList[pageIndex] {
                guard let model = self.pageDataList[pageIndex]?.items[itemIndex] else { return cell }
                cell.configure(with: CellViewModel(item: model))
                return cell
            }
            
            networkManager.getItemsOfPageData(pagination: false, pageNumber: pageIndex) { [weak self] data, pageNumber in
                do {
                    let data = try JSONDecoder().decode(ItemsOfPageReponse.self, from: data!)
                    self?.pageDataList[pageIndex] = data
                    guard let pageData = self?.pageDataList[pageIndex] else { return }
                    let model = pageData.items[itemIndex]
                    DispatchQueue.main.async {
                        self?.numberOfItems += self?.pageDataList[pageIndex]?.items.count ?? 0
                        if representedIdentifier == cell.representedIdentifier {
                            cell.configure(with: CellViewModel(item: model))
                        }
                        self?.collectionView.reloadData()
                    }
                } catch {
                    fatalError("Failed to decode")
                }
            }
            return cell
            

        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCollectionViewIdentifier, for: indexPath) as? ListCollectionViewCell else  {
                return UICollectionViewCell()
            }
            
            cell.representedIdentifier = representedIdentifier
            cell.accessories = [.disclosureIndicator()]
            
            if let _ = self.pageDataList[pageIndex] {
                guard let model = self.pageDataList[pageIndex]?.items[itemIndex] else { return cell }
                cell.configure(with: CellViewModel(item: model))
                return cell
            }
         
            networkManager.getItemsOfPageData(pagination: false, pageNumber: pageIndex) { [weak self] data, pageNumber in
                do {
                    let data = try JSONDecoder().decode(ItemsOfPageReponse.self, from: data!)
                    self?.pageDataList[pageIndex] = data
                    guard let pageData = self?.pageDataList[pageIndex] else { return }
                    let model = pageData.items[itemIndex]
                    DispatchQueue.main.async {
                        self?.numberOfItems += self?.pageDataList[pageIndex]?.items.count ?? 0
                        if representedIdentifier == cell.representedIdentifier {
                            cell.configure(with: CellViewModel(item: model))
                        }
                        self?.collectionView.reloadData()
                    }
                } catch {
                    fatalError("Failed to decode")
                }
            }
            return cell
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let indicatorView = IndicatorView.shared
        if offsetY > contentHeight - scrollView.frame.height {
            guard !networkManager.isPaginating else {
                return
            }
            indicatorView.showIndicator()
            networkManager.getItemsOfPageData(pagination: true, pageNumber: pageDataList.count + 1) { [weak self] data, pageNumber in
                do {
                    let data = try JSONDecoder().decode(ItemsOfPageReponse.self, from: data!)
                    guard let pageNumber = self?.pageDataList.count else { return }
                    self?.pageDataList[pageNumber + 1] = data
                    DispatchQueue.main.async {
                        self?.numberOfItems += self?.pageDataList[pageNumber+1]?.items.count ?? 0
                        self?.collectionView.reloadData()
                        indicatorView.dismiss()
                    }
                } catch {
                    fatalError("Failed to decode")
                }
            }
            
        }
    }
    
}

@available(iOS 14.0, *)
extension ItemListViewController: UICollectionViewDelegate {
    
}

@available(iOS 14.0, *)
extension ItemListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if reuseCollectionViewIdentifier == ListCollectionViewCell.identifier {
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


