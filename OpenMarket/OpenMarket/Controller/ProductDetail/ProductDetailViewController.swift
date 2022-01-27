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
            self.productDiscountedPriceLabel.text = viewModel.productOriginalPriceText
            self.productPriceLabel.text = viewModel.productDiscountedPriceText
            self.productDescriptionTextField.text = viewModel.productDescriptionText
            self.imageSlider.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationVC = segue.destination as? UINavigationController,
           let modifyVC = navigationVC.topViewController as? ProductModifyViewController,
           let product = sender as? Product {
            modifyVC.id = product.id
        }
    }
    
    @IBAction func actionButtonClicked(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        [
            UIAlertAction(title: "수정", style: .default,
                          handler: modifyProductHandler),
            UIAlertAction(title: "삭제", style: .destructive,
                          handler: deleteProductHandler),
            UIAlertAction(title: "취소", style: .cancel)
        ].forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
    
    @IBAction func unwindToProductDetailView(_ segue: UIStoryboardSegue) { }

}

// MARK: - UIAlertController ActionSheet Handler
private extension ProductDetailViewController {
    
    func modifyProductHandler(_ action: UIAlertAction) {
        performSegue(withIdentifier: "productModifySegue", sender: viewModel.product)
    }
    
    func deleteProductHandler(_ action: UIAlertAction) {
        
    }
    
}
