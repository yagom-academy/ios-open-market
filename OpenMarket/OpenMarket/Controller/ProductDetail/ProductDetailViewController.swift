//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/25.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    private(set) lazy var viewModel = ProductDetailViewModel(id: self.id, viewHandler: self.updateUI)
    var id: Int = 0

    @IBOutlet private weak var imageSlider: ImageSlider!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productStockLabel: UILabel!
    @IBOutlet private weak var productDiscountedPriceLabel: UILabel!
    @IBOutlet private weak var productPriceLabel: UILabel!
    @IBOutlet private weak var productDescriptionTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageSlider.delegate = viewModel
        viewModel.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            let viewModel = self.viewModel
            self.productNameLabel.text = viewModel.productNameText
            self.productStockLabel.text = viewModel.productStockText
            self.productDiscountedPriceLabel.text = viewModel.productDiscountedText
            self.productPriceLabel.text = viewModel.productPriceText
            self.productDescriptionTextField.text = viewModel.productDescriptionText
            self.imageSlider.reloadData()
        }
    }

}
