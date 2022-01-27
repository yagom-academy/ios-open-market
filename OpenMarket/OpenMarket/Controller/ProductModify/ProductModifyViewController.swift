//
//  ProductModifyViewController.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/27.
//

import UIKit

class ProductModifyViewController: UIViewController {
    
    private lazy var viewModel = ProductModifyViewModel(id: self.id, viewHandler: self.updateUI)
    
    @IBOutlet weak var productRegisterView: ProductRegisterView!
    
    var id: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProductRegisterView()
        viewModel.viewDidLoad()
        
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.productRegisterView.reloadData()
        }
    }
    
    @IBAction func doneButtonClicked(_ sender: UIBarButtonItem) {
        viewModel.doneButtonClicked(form: form) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.performSegue(withIdentifier: "popToProductPageSegue", sender: nil)
                case .failure(let error):
                    let title = "오류가 발생하였습니다"
                    let message = "상품 수정 등록 중 \(error)가 발생되었습니다"
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    [
                        UIAlertAction(title: "확인", style: .default),
                        UIAlertAction(title: "취소", style: .cancel)
                    ].forEach { alert.addAction($0) }
                    self.present(alert, animated: true)
                }
            }
        }
    }
}

// MARK: - Controller Configure Functions
private extension ProductModifyViewController {
    
    func configureProductRegisterView() {
        productRegisterView.delegate = viewModel
        productRegisterView.productImageAddButton.isHidden = true
    }
    
    var form: ProductRegisterForm {
        ProductRegisterForm(
            name: productRegisterView.productNameTextField.text ?? "",
            price: productRegisterView.productPriceTextField.text ?? "",
            currency: productRegisterView.currencySegmentedControl.currentText,
            discountedPrice: productRegisterView.discountedPriceTextField.text ?? "0",
            stock: productRegisterView.productStockTextField.text ?? "0",
            description: productRegisterView.descriptionTextView.text ?? ""
        )
    }
    
}
