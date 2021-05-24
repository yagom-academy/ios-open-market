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

extension ItemListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pageIndex = indexPath.item / 20 + 1
        let itemIndex = indexPath.item % 20
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCollectionViewIdentifier, for: indexPath) as? ListCollectionViewCell else  {
            return UICollectionViewCell()
        }
        
        let representedIdentifier = String(describing: indexPath)
        cell.representedIdentifier = representedIdentifier
        
        if let _ = self.pageDataList[pageIndex] {
            print("@: \(pageDataList.count)")
            print("using cached data")
            guard let item = self.pageDataList[pageIndex]?.items[itemIndex] else { return cell }
            cell.update(data: item)
            return cell
        }
     
        networkManager.getItemsOfPageData(pagination: false, pageNumber: pageIndex) { [weak self] data, pageNumber in
            do {
                let data = try JSONDecoder().decode(ItemsOfPageReponse.self, from: data!)
                self?.pageDataList[pageIndex] = data
                guard let pageData = self?.pageDataList[pageIndex] else { return }
                let item = pageData.items[itemIndex]
                DispatchQueue.main.async {
                    self?.numberOfItems += self?.pageDataList[pageIndex]?.items.count ?? 0
                    if representedIdentifier == cell.representedIdentifier {
                        cell.update(data: item)
                    }
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
        let indicatorView = IndicatorView.shared
        if offsetY > contentHeight - scrollView.frame.height {
            guard !networkManager.isPaginating else {
                return
            }
            indicatorView.show()
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

extension ItemListViewController: UICollectionViewDelegate {
    
}


extension ItemListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if reuseCollectionViewIdentifier == ListCollectionViewCell.identifier {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/8)
        }

        return CGSize(width: collectionView.frame.width/2-20, height: collectionView.frame.height/3.5)
    }
}






//
//
//
//import UIKit
//
//class ItemListViewController: UIViewController {
//
//    var pageDataList: [Int : ItemsOfPageReponse] = [:]
//    var reuseCollectionViewIdentifier = ListCollectionViewCell.identifier
//
//    @IBOutlet var collectionView: UICollectionView!
//    @IBOutlet var control: UISegmentedControl!
//    @IBAction func didChangeSegement(_ sender: UISegmentedControl) {
//        if sender.selectedSegmentIndex == 0 {
//            reuseCollectionViewIdentifier = ListCollectionViewCell.identifier
//            registerCollectionViewCellNib()
//            collectionView.reloadData()
//            return
//        }
//
//        reuseCollectionViewIdentifier = GridCollectionViewCell.identifier
//        registerCollectionViewCellNib()
//        collectionView.reloadData()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setUpSegmentedControl()
//        setUpCollectionView()
//        getItemsOfPageData(itemNumber: 0)
//    }
//
////    private func checkPageExist(_ pageNumber: Int) -> [Bool] {
////        var pageCheckList = [false, false, false]
////        for pageData in pageDataList {
////            if pageData.page == pageNumber - 1 { pageCheckList[0] = true }
////            if pageData.page == pageNumber { pageCheckList[1] = true }
////            if pageData.page == pageNumber + 1 { pageCheckList[2] = true }
////        }
////        return pageCheckList
////    }
//
//    private func setUpCollectionView() {
//        self.collectionView.delegate = self
//        self.collectionView.dataSource = self
//        registerCollectionViewCellNib()
//    }
//
//    private func registerCollectionViewCellNib() {
//        let collectionViewNib = UINib(nibName: reuseCollectionViewIdentifier, bundle: nil)
//        self.self.collectionView.register(collectionViewNib, forCellWithReuseIdentifier: reuseCollectionViewIdentifier)
//    }
//
//    private func setUpSegmentedControl() {
//        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue],
//                                       for: UIControl.State.normal)
//        control.layer.borderWidth = 0.5
//        control.layer.borderColor = UIColor.systemBlue.cgColor
//        control.backgroundColor = UIColor.white
//        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white],
//                                       for: UIControl.State.selected)
//    }
//
//    func checkValidation(data: Data?, response: URLResponse?, error: Error?) {
//        if let error = error {
//            fatalError("\(error)")
//        }
//        guard let httpResponse = response as? HTTPURLResponse else {
//            print("Invalid Response")
//            return
//        }
//        guard (200...299).contains(httpResponse.statusCode) else {
//            print("Status Code: \(httpResponse.statusCode)")
//            return
//        }
//        guard let _ = data else {
//            print("Invalid Data")
//            return
//        }
//    }
//
//    func getItemsOfPageData(itemNumber: Int)  {
//        let pageNumber = itemNumber / 20 + 1
//
//        if let _ = pageDataList[pageNumber] {
//            print("using cached data")
//            return
//        }
//
//        let url = Network.baseURL + "/items/\(pageNumber)"
//        guard let urlRequest = URL(string: url) else { return  }
//
//        URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
//            self?.checkValidation(data: data, response: response, error: error)
//            do {
//                let data = try JSONDecoder().decode(ItemsOfPageReponse.self, from: data!)
//                self?.pageDataList[pageNumber] = data
//                self?.collectionView.reloadData()
//            } catch {
//                fatalError("Failed to decode")
//            }
//        }.resume()
//    }
//}
//
//extension ItemListViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return pageDataList.count * 20
//    }
//
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        print("% willDisplay : \(indexPath)")
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print("@ \(indexPath)")
//        if reuseCollectionViewIdentifier == GridCollectionViewCell.identifier {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCollectionViewIdentifier, for: indexPath) as? GridCollectionViewCell else  {
//                return UICollectionViewCell()
//            }
//            getItemsOfPageData(itemNumber: indexPath.item)
//            return cell
//        } else {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCollectionViewIdentifier, for: indexPath) as? ListCollectionViewCell else  {
//                return UICollectionViewCell()
//            }
//            getItemsOfPageData(itemNumber: indexPath.item)
//            return cell
//        }
//    }
//}
//
//extension ItemListViewController: UICollectionViewDelegate {
//
//}
//
//extension ItemListViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        if reuseCollectionViewIdentifier == ListCollectionViewCell.identifier {
//            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/8)
//        }
//
//        return CGSize(width: collectionView.frame.width/2-20, height: collectionView.frame.height/3.5)
//    }
//}
