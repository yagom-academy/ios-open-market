//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var networkCommunication = NetworkCommunication()
    var searchListProducts: SearchListProducts?
    var searchListPages: [SearchListPage] = []
    var detailProduct: DetailProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        getResponseAboutHealChecker()
        getProductsListData()
        getProductDetailData(productNumber: "31")
        getCollectionViewCellNib()
        settingCollectionViewLayoutList()
        settingSegmentedControll()
    }
    
    @IBAction func tapSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            settingCollectionViewLayoutList()
        } else {
            settingCollectionViewLayoutGrid()
        }
    }
    
    private func getCollectionViewCellNib() {
        collectionView.register(UINib(nibName: "CustomCollectionViewListCell", bundle: nil), forCellWithReuseIdentifier: "customCollectionViewListCell")
        collectionView.register(UINib(nibName: "CustomCollectionViewGridCell", bundle: nil), forCellWithReuseIdentifier: "customCollectionViewGridCell")
    }
    
    private func getResponseAboutHealChecker() {
        networkCommunication.requestHealthChecker(
            url: ApiUrl.Path.healthChecker) { response in
                switch response {
                case .success(let response):
                    print("코드\(response.statusCode): 연결완료")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    private func getProductsListData(pageNumber: String = "1", itemPerPage: String = "100") {
        networkCommunication.requestProductsInformation(
            url: ApiUrl.Path.products +
            ApiUrl.Query.pageNumber +
            pageNumber +
            ApiUrl.Query.itemsPerPage +
            itemPerPage,
            type: SearchListProducts.self
        ) { data in
            switch data {
            case .success(let data):
                self.searchListProducts = data
                self.searchListPages = data.pages
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getProductDetailData(productNumber: String) {
        networkCommunication.requestProductsInformation(
            url: ApiUrl.Path.detailProduct + productNumber,
            type: DetailProduct.self
        ) { data in
            switch data {
            case .success(let data):
                self.detailProduct = data
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func settingSegmentedControll() {
        segmentedControl.setWidth(view.bounds.width/4, forSegmentAt: 0)
        segmentedControl.setWidth(view.bounds.width/4, forSegmentAt: 1)
        segmentedControl.layer.borderColor = UIColor.systemBlue.cgColor
        segmentedControl.layer.borderWidth = CGFloat(2)
        segmentedControl.selectedSegmentTintColor = UIColor.systemBlue
        segmentedControl.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: UIControl.State.normal)
    }
    
    private func settingCollectionViewLayoutList() {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(70))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                             subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        let compositionalLayout = UICollectionViewCompositionalLayout(section: layoutSection)
        collectionView.collectionViewLayout = compositionalLayout
        self.collectionView.reloadData()
    }
    
    private func settingCollectionViewLayoutGrid() {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(0.4))
        let layoutGruop = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: layoutItem, count: 2)
        let layoutSection = NSCollectionLayoutSection(group: layoutGruop)
        let compositionalLayout = UICollectionViewCompositionalLayout(section: layoutSection)
        collectionView.collectionViewLayout = compositionalLayout
        self.collectionView.reloadData()
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchListPages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell: CustomCollectionViewCell
        if segmentedControl.selectedSegmentIndex == 0 {
            customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionViewListCell", for: indexPath) as? CustomCollectionViewCell ?? CustomCollectionViewCell()
        } else {
            customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionViewGridCell", for: indexPath) as? CustomCollectionViewCell ?? CustomCollectionViewCell()
            customCell.layer.cornerRadius = CGFloat(10)
            customCell.layer.borderWidth = CGFloat(3)
            customCell.layer.borderColor = UIColor.systemGray3.cgColor
        }
        
        customCell.configureCell(imageSource: self.searchListPages[indexPath.item].thumbnail,
                                 name: self.searchListPages[indexPath.item].name,
                                 currency: self.searchListPages[indexPath.item].currency,
                                 price: self.searchListPages[indexPath.item].price,
                                 bargainPrice: self.searchListPages[indexPath.item].bargainPrice,
                                 stock: self.searchListPages[indexPath.item].stock)
        return customCell
    }
    
    
}

extension ViewController: UICollectionViewDelegate {
    
}
