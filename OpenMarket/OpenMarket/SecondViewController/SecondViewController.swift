//
//  SecondViewController.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/20.
//

import UIKit

final class SecondViewController: UIViewController {
    @IBOutlet weak var productCollectionView: UICollectionView!
    
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

extension SecondViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let result = productData else { return 0 }
        return result.itemsPerPage
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondCell", for: indexPath) as! SecondCollectionViewCell
        
        guard let result = productData,
              let imageURL: URL = URL(string: result.pages[indexPath.row].thumbnail),
              let imageData: Data = try? Data(contentsOf: imageURL) else {
            return cell
        }
        
        let productStock = result.pages[indexPath.row].stock
        guard let priceNumberFormatter = numberFormatter.string(from: result.pages[indexPath.row].price as NSNumber) else { return cell }
        guard let dicountedPriceNumberFormatter = numberFormatter.string(from: result.pages[indexPath.row].discountedPrice as NSNumber) else { return cell }

        if productStock == 0 {
            cell.productStock.text = "품절"
            cell.productStock.textColor = .orange
        } else {
            cell.productStock.text = "잔여수량 : \(productStock)"
            cell.productStock.textColor = .systemGray
        }
        
        if result.pages[indexPath.row].bargainPrice > 0 {
            cell.productDiscountPrice.attributedText = cell.productPrice.text?.strikeThrough()
            cell.productDiscountPrice.text = "\(result.pages[indexPath.row].currency): \(priceNumberFormatter)"
            cell.productDiscountPrice.textColor = .systemRed
            
            cell.productPrice.text = "\(result.pages[indexPath.row].currency): \(dicountedPriceNumberFormatter)"
            cell.productPrice.textColor = .systemGray
        } else {
            cell.productPrice.text = "\(result.pages[indexPath.row].currency): \(priceNumberFormatter)"
            cell.productPrice.textColor = .systemGray
        }
        
        cell.productImage.image = UIImage(data: imageData)
        cell.productName.text = result.pages[indexPath.row].name

        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 20
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.isSelected = false
        return cell
    }
}

extension SecondViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        flowayout?.minimumLineSpacing = 10.0
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0) + 10
        let size:CGFloat = (productCollectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
}
