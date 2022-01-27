//
//  ProductModifyViewController.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/27.
//

import UIKit

class ProductModifyViewController: UIViewController {
    
    private lazy var viewModel = ProductModifyViewModel(
        id: self.id, viewHandler: self.updateUI
    )
    
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
    
}

// MARK: - Controller Configure Functions
private extension ProductModifyViewController {
    
    func configureProductRegisterView() {
        productRegisterView.delegate = viewModel
        productRegisterView.productImageAddButton.isHidden = true
    }
    
}
