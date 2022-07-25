//
//  GridViewController.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/20.
//

import UIKit

final class GridViewController: UIViewController {
    @IBOutlet private weak var productCollectionView: UICollectionView!
    
    private let numberFormatter = NumberFormatter()
    private let jsonParser = JSONParser()
    private let URLSemaphore = DispatchSemaphore(value: 0)
    private let itemPage = "items_per_page=20"
    private var productData: ProductListResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        settingNumberFormaatter()
        self.fetchData()
    }
    
    private func settingNumberFormaatter() {
        numberFormatter.roundingMode = .floor
        numberFormatter.numberStyle = .decimal
    }
    
    private func fetchData() {
        jsonParser.dataTask(by: URLCollection.productListInquery + itemPage, completion: { (response) in
            switch response {
            case .success(let data):
                self.productData = data
                self.URLSemaphore.signal()
            case .failure(let data):
                print(data)
            }
        })
        URLSemaphore.wait()
    }
}

extension GridViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let result = productData else { return 0 }
        return result.itemsPerPage
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.reuseIdentifier, for: indexPath) as! GridCollectionViewCell
        cell.fetchData(data: productData, index: indexPath.row)
        
        return cell
    }
}

extension GridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        flowayout?.minimumLineSpacing = 10.0
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0) + 10
        let size:CGFloat = (productCollectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
}
