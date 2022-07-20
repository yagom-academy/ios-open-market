//
//  FirstViewController.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/19.
//

import UIKit

class FirstViewController: UIViewController {
    @IBOutlet weak var productCollectionView: UICollectionView!

    let jsonParser = JSONParser()
    let URLSemaphore = DispatchSemaphore(value: 0)
    var productData: ProductListResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        productCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self

        self.setData()
    }
    
    func setData() {
        jsonParser.dataTask(by: URLCollection.productListInquery, completion: { (response) in
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

extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let result = productData else { return 0 }
        return result.itemsPerPage
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FirstCollectionViewCell

        guard let result = productData,
              let imageURL: URL = URL(string: result.pages[indexPath.row].thumbnail),
              let imageData: Data = try? Data(contentsOf: imageURL) else {
            return cell
        }
        cell.accessories = [.disclosureIndicator()]

        let productStock = result.pages[indexPath.row].stock
        
        if productStock == 0 {
            cell.productStock.text = "품절"
            cell.productStock.textColor = .orange
        } else {
            cell.productStock.text = "잔여수량 : \(productStock)"
            cell.productStock.textColor = .systemGray
        }
        
        if result.pages[indexPath.row].bargainPrice > 0 {
            cell.productPrice.attributedText = cell.productPrice.text?.strikeThrough()
            cell.productPrice.text = "\(result.pages[indexPath.row].currency): \(result.pages[indexPath.row].price)"
            cell.productPrice.textColor = .systemRed
            cell.productDiscountPrice.text = "\(result.pages[indexPath.row].currency): \(result.pages[indexPath.row].discountedPrice)"
            cell.productDiscountPrice.textColor = .systemGray
        } else {
            cell.productPrice.text = "\(result.pages[indexPath.row].currency): \(result.pages[indexPath.row].price)"
            cell.productPrice.textColor = .systemGray
        }
        
        cell.productImage.image = UIImage(data: imageData)
        cell.productName.text = result.pages[indexPath.row].name
        cell.isSelected = false
        return cell
    }
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}
