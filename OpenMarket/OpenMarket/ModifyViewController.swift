//
//  ModifyViewController.swift
//  OpenMarket
//
//  Created by 김태훈 on 2022/05/24.
//

import UIKit

class ModifyViewController: UIViewController {
    var product: Product?
    lazy var productView = ProductView(frame: view.frame)
    var currency: Currency = .KRW

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = productView
        self.view.backgroundColor = .white
        
        self.navigationItem.title = "상품수정"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneToMain))
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.hidesBackButton = true
        let backbutton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backToMain))
        backbutton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.preferredFont(for: .body, weight: .semibold)], for: .normal)
        self.navigationItem.leftBarButtonItem = backbutton
        
        productView.collectionView.delegate = self
        productView.collectionView.dataSource = self
        
        productView.currencyField.addTarget(self, action: #selector(changeCurrency(_:)), for: .valueChanged)
        fillData()
    }
    
    func fillData() {
        guard let product = product else {
            return
        }
        
        productView.currencyField.selectedSegmentIndex = product.currency!.value
        self.changeCurrency(productView.currencyField)
        
        productView.nameField.text = product.name
        productView.priceField.text = String(product.price)
        productView.stockField.text = String(product.stock)
        productView.descriptionField.text = product.description
        productView.discountedPriceField.text = String(product.discountedPrice)
    }
    
    @objc func changeCurrency(_ sender: UISegmentedControl) {
        let mode = sender.selectedSegmentIndex
        if mode == Currency.KRW.value {
            currency = Currency.KRW
        } else if mode == Currency.USD.value {
            currency = Currency.USD
        }
    }
}

extension ModifyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width * 0.4, height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let images = product?.images else {
            return .zero
        }
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageRegisterCell else {
            return ImageRegisterCell()
        }
        guard let images = product?.images else {
            return ImageRegisterCell()
        }
        cell.plusButton.isHidden = true
        cell.imageView.requestImageDownload(url: images[indexPath.row].url)
        return cell
    }
    
    @objc func doneToMain() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backToMain() {
        self.navigationController?.popViewController(animated: true)
    }
}
