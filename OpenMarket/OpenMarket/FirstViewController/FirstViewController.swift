//
//  FirstViewController.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/19.
//

import UIKit

final class FirstViewController: UIViewController {
    @IBOutlet weak var productCollectionView: UICollectionView!
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.isHidden = false
        return activityIndicator
    }()
    
    private let numberFormatter = NumberFormatter()
    private let jsonParser = JSONParser()
    private let URLSemaphore = DispatchSemaphore(value: 0)
    private let itemPage = "items_per_page=20"
    private var productData: ProductListResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(activityIndicator)
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        self.fetchUICollectionViewConfiguration()
        self.settingNumberFormaatter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.activityIndicator.startAnimating()
        self.setData()
        self.activityIndicator.stopAnimating()
    }
    
    private func fetchUICollectionViewConfiguration() {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        productCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
    }

    private func settingNumberFormaatter() {
        numberFormatter.roundingMode = .floor
        numberFormatter.numberStyle = .decimal
    }
    
    private func setData() {
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
        self.productCollectionView.reloadData()
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
        let isCheckPrice = result.pages[indexPath.row].bargainPrice
        guard let priceNumberFormatter = numberFormatter.string(from: result.pages[indexPath.row].price as NSNumber) else { return cell }
        guard let dicountedPriceNumberFormatter = numberFormatter.string(from: result.pages[indexPath.row].discountedPrice as NSNumber) else { return cell }
        
        cell.productImage.image = UIImage(data: imageData)
        cell.productName.text = result.pages[indexPath.row].name
        cell.productPrice.attributedText = .none
        cell.productDiscountPrice.attributedText = .none
        cell.spacingView.isHidden = true
        cell.isSelected = false
        
        if productStock == 0 {
            cell.productStock.text = "품절"
            cell.productStock.textColor = .orange
        } else {
            cell.productStock.text = "잔여수량 : \(productStock)"
            cell.productStock.textColor = .systemGray
        }
        
        if isCheckPrice > 0 {
            cell.spacingView.isHidden = false
            cell.productPrice.textColor = .systemRed
            cell.productPrice.text = "\(result.pages[indexPath.row].currency): \(priceNumberFormatter)"
            cell.productPrice.attributedText = cell.productPrice.text?.strikeThrough()
            cell.productDiscountPrice.textColor = .systemGray
            cell.productDiscountPrice.text = "\(result.pages[indexPath.row].currency): \(dicountedPriceNumberFormatter)"
        } else {
            cell.productDiscountPrice.textColor = .systemGray
            cell.productDiscountPrice.text = "\(result.pages[indexPath.row].currency): \(priceNumberFormatter)"
        }
        return cell
    }
}
