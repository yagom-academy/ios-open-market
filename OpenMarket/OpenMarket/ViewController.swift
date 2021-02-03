//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    private let testArray = [
        "https://wallpaperaccess.com/download/europe-4k-1369012",
        "https://wallpaperaccess.com/download/europe-4k-1318341",
        "https://wallpaperaccess.com/download/europe-4k-1379801"
    ]
    enum SegmentValueTypes: Int, CaseIterable {
        case list = 0
        case grid
        
        var valueString: String {
            switch self {
            case .list:
                return "List"
            case .grid:
                return "Grid"
            }
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    private lazy var collectionViewLayouts: [UICollectionViewFlowLayout] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        
        table.register(UINib(nibName: "TestTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    
//        MarketGoodsListModel.fetchMarketGoodsList(page: 1) { result in
//            switch result {
//            case .success(let data):
//                debugPrint("👋: \(data)")
//            case .failure(let error):
//                debugPrint("❌:\(error.localizedDescription)")
//            }
//        }
//        GoodsModel.fetchGoods(id: 1) { result in
//            switch result {
//            case .success(let data):
//                debugPrint("👋: \(data)")
//            case .failure(let error):
//                debugPrint("❌:\(error.localizedDescription)")
//            }
//        }
        
        let testImage = UIImage(systemName: "pencil")!
        let form = try? GoodsForm(registerPassword: "1234", title: "test-joons", descriptions: "test-joons", price: 10000, currency: "KRW", stock: 1, discountedPrice: nil, images: [testImage, testImage]).makeRegisterForm()
        
        GoodsModel.registerGoods(params: form!) { result in
            switch result {
            case .success(let data):
                debugPrint("👋: \(data)")
            case .failure(let error):
                debugPrint("❌:\(error.localizedDescription)")
            }
        }
        
//        let editForm = try? GoodsForm(editPassword: "1234", title: "test-test-joons", descriptions: nil, price: nil, currency: nil, stock: nil, discountedPrice: nil, images: nil).makeEditForm()
//        GoodsModel.editGoods(id: 67, params: editForm!) { result in
//            switch result {
//            case .success(let data):
//                debugPrint("👋: \(data)")
//            case .failure(let error):
//                debugPrint("❌:\(error.localizedDescription)")
//            }
//        }
        setUpCollectionViewLayouts()
        setUpCollection()
        setUpSegment()
    }
    
    // MARK: - setUp Segment
    private func setUpSegment() {
        for (index, element) in SegmentValueTypes.allCases.enumerated() {
            segment.setTitle(element.valueString, forSegmentAt: index)
        }
        segment.addTarget(self, action: #selector(changedSegmentValue(_:)), for: .valueChanged)
        reloadCollectionView()
    }
    
    @objc func changedSegmentValue(_ sender: UISegmentedControl) {
        reloadCollectionView()
    }
    
    // MARK: - setUp CollectionView
    private func setUpCollectionViewLayouts() {
        for valueType in SegmentValueTypes.allCases {
            switch valueType {
            case .list:
                collectionViewLayouts.append(makeListCollectionViewLayout())
            case .grid:
                collectionViewLayouts.append(makeGridCollectionViewLayout())
            }
        }
    }
    
    private func makeListCollectionViewLayout() -> UICollectionViewFlowLayout {
        // TODO: Lasagna - add CollectionView List Type Layout
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 90)
        return layout
    }
    
    private func makeGridCollectionViewLayout() -> UICollectionViewFlowLayout {
        // TODO: Joons - add CollectionView Grid Type Layout
        // This is test layout code
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 30, height: 90)
        return layout
    }
    
    private func setUpCollection() {
        collectionView.dataSource = self
        // test cell, will delete
        collectionView.register(UINib(nibName: "TestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        // TODO: Lasagna - CollectionView List Type cell regist
        // TODO: Joons - CollectionView Grid Type cell Regist
    }
    
    private func reloadCollectionView() {
        collectionView.collectionViewLayout = collectionViewLayouts[segment.selectedSegmentIndex]
        self.collectionView.reloadData()
    }
    
    @IBAction func touchUpAddButton(_ sender: UIButton) {
        // TODO: add logic in step3
        print("➕")
    }
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 42
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TestTableViewCell else {
            return UITableViewCell()
        }
        let token = ImageLoader.shared.load(urlString: self.testArray[indexPath.row % 3]) { result in
            switch result {
            case .failure(let error):
                debugPrint("❌:\(error.localizedDescription)")
            case .success(let image):
                DispatchQueue.main.async {
                    if let index: IndexPath = tableView.indexPath(for: cell) {
                        if index.row == indexPath.row {
                            cell.testImage.image = image
                        }
                    }
                }
            }
        }
        cell.onReuse = {
            if let token = token {
                ImageLoader.shared.cancelLoad(token)
            }
        }
        return cell
    }
    
    
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TestCollectionViewCell
        return cell
    }
    
}
