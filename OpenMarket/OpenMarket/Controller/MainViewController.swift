//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
    var productList: [Product] = []
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var segmentControl: UISegmentedControl! {
        didSet {
            let normal: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
            let selected: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black]
            segmentControl.setTitleTextAttributes(normal, for: .normal)
            segmentControl.setTitleTextAttributes(selected, for: .selected)
            segmentControl.selectedSegmentTintColor = .white
            segmentControl.backgroundColor = .black
        }
    }
    var currentCellIdentifier = ProductCell.listIdentifier
    
    private var listFlowlayout: UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        let halfWidth = UIScreen.main.bounds.width
        flowLayout.itemSize = CGSize(width: halfWidth, height: halfWidth * 0.155)
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumLineSpacing = 0
        return flowLayout
    }
    
    private var gridFlowlayout: UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        let halfWidth = UIScreen.main.bounds.width / 2
        flowLayout.itemSize = CGSize(width: halfWidth * 0.93, height: halfWidth * 1.32)
        let spacing = (UIScreen.main.bounds.width - flowLayout.itemSize.width * 2) / 3
        flowLayout.sectionInset = UIEdgeInsets.init(top: 10, left: spacing, bottom: 10, right: spacing)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = spacing
        self.collectionView.collectionViewLayout = flowLayout
        return flowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        registerXib()
        setUpListFlowLayout()
        requestProducts()
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func requestProducts() {
        let networkManager: NetworkManager = NetworkManager()
        guard let request = networkManager.requestListSearch(page: 1, itemsPerPage: 10) else {
            return
        }
        
        networkManager.fetch(request: request, decodingType: Products.self) { result in
            switch result {
            case .success(let products):
                self.productList = products.pages
                self.reload()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func registerXib() {
        let gridNibName = UINib(nibName: ProductCell.listNibName, bundle: .main)
        collectionView.register(gridNibName, forCellWithReuseIdentifier: ProductCell.listIdentifier)
        
        let listNibName = UINib(nibName: ProductCell.gridNibName, bundle: .main)
        collectionView.register(listNibName, forCellWithReuseIdentifier: ProductCell.gridItentifier)
    }
    
    private func setUpListFlowLayout() {
        collectionView.collectionViewLayout = listFlowlayout
    }
    
    private func setUpGridFlowLayout() {
        collectionView.collectionViewLayout = gridFlowlayout
    }
    
    @IBAction func switchSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentCellIdentifier = ProductCell.listIdentifier
            setUpListFlowLayout()
            collectionView.scrollToTop()
            collectionView.reloadData()
        case 1:
            currentCellIdentifier = ProductCell.gridItentifier
            setUpGridFlowLayout()
            collectionView.scrollToTop()
            collectionView.reloadData()
        default:
            return
        }
    }
    
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
      cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: currentCellIdentifier,
            for: indexPath) as? ProductCell else {
            fatalError()
        }
        cell.styleConfigure(identifier: currentCellIdentifier)
        
        cell.productConfigure(product: productList[indexPath.row])
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {

}

extension UIScrollView {
    func scrollToTop() {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: false)
    }
}
