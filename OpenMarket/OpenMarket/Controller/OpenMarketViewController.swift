//
//  OpenMarket - OpenMarketViewController.swift
//  Created by groot, bard. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    enum Section {
        case list
    }
    
    var productsList = [ProductDetail]()
    var dataSource: UICollectionViewDiffableDataSource<Section, ProductDetail>? = nil
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["List", "Grid"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    var listView: UICollectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let listView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        listView.translatesAutoresizingMaskIntoConstraints = false
        return listView
    }()
    
    let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,
                                                                ProductDetail> { (cell, indexPath, item) in
        guard let url = URL(string: item.thumbnail) else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        
        var content = cell.defaultContentConfiguration()
        content.text = item.name
        let first = "\(item.currency.rawValue) \(item.price.description)"
        let second = "\(item.currency.rawValue) \(item.bargainPrice.description)"
        let attributeString = NSMutableAttributedString(string: "\(first) \(second)")
        attributeString.addAttributes([
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.systemRed
        ], range: NSMakeRange(0, first.count))
        content.secondaryAttributedText = attributeString
        content.image = UIImage(data: data)
        content.imageProperties.maximumSize = CGSize(width: 70, height: 70)
        let options = UICellAccessory.OutlineDisclosureOptions(style: .header)
        let accessory = UICellAccessory.disclosureIndicator()
        var text = "잔여수량 : \(item.stock)"
        if item.stock == 0 {
            text = "품절"
            let soldOutAccessory = UICellAccessory.label(text: text,
                                                         options: .init(tintColor: .systemOrange,
                                                                        font: .preferredFont(forTextStyle: .footnote)))
            cell.accessories = [soldOutAccessory, accessory]
        } else {
            let stockAccessory = UICellAccessory.label(text: text,
                                                       options: .init(font: .preferredFont(forTextStyle: .footnote)))
            cell.accessories = [stockAccessory, accessory]
        }
        cell.contentConfiguration = content
    }
    
    let gridView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let gridView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        gridView.backgroundColor = .yellow
        gridView.translatesAutoresizingMaskIntoConstraints = false

        return gridView
    }()
    
    var shouldHideListView: Bool? {
        didSet {
            guard let shouldHideListView = self.shouldHideListView else { return }
            self.listView.isHidden = shouldHideListView
            self.gridView.isHidden = !self.listView.isHidden
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        self.fetchData()
        self.setSubviews()
        self.setNavigationController()
        self.setSegmentedControl()
        self.configureDataSource()
    }
    
    @objc func segmentButtonDidTap(sender: UISegmentedControl) {
        self.shouldHideListView = (sender.selectedSegmentIndex != 0)
    }
    
    @objc func productRegistrationButtonDidTap() {
        print("productRegistrationButtonDidTapped")
    }
    
    private func fetchData() {
        let productsRequest = ProductsRequest()
        let myURLSession = MyURLSession()
        myURLSession.dataTask(with: productsRequest) { (result: Result<ProductsDetailList, Error>) in
            switch result {
            case .success(let success):
                for number in 0...29 {
                    self.productsList.append(success.pages[number])
                }
                if self.productsList.count == 30 {
                    self.configurationSnapshot()
                }
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ProductDetail>(collectionView: listView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: ProductDetail) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    private func configurationSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductDetail>()
        snapshot.appendSections([.list])
        snapshot.appendItems(productsList)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

struct ProductsRequest: APIRequest {
    var path: URLAdditionalPath = .product
    var method: HTTPMethod = .get
    var baseURL: String {
        URLHost.openMarket.url + path.value
    }
    var headers: [String : String]?
    var query: [URLQueryItem]? {
        [
            URLQueryItem(name: "page_no", value: "\(1)"),
            URLQueryItem(name: "items_per_page", value: "\(30)")
        ]
    }
    var body: Data?
}
