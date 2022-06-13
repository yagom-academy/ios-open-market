//
//  EditViewController.swift
//  OpenMarket
//
//  Created by marlang, Taeangel on 2022/05/29.
//

import UIKit

fileprivate enum Const {
    static let error = "ERROR"
    static let cancel = "Cancel"
    static let done = "Done"
    static let really = "Really?"
    static let patchSuccess = "Patch Success"
}

final class EditViewController: ProductViewController {
    private let product: DetailProduct

    override func viewDidLoad() {
        super.viewDidLoad()
        view = baseView
        managementType = ManagementType.edit
        setupNavigationItems()
        getDetailData()
    }
    
    init(product: DetailProduct) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getDetailData() {
        
        guard let id = product.id else {
            return
        }

        network.fetchData(from: .detailProduct(id: id)) { result in
            switch result {
            case .success(let product):
                self.baseView.setupEditView(product: product)
            case .failure(let error):
                self.showAlert(title: Const.error, message: error.errorDescription)
            }
        }
    }
    
    private func patchData() {
        
        guard let id = product.id else {
            return
        }
        
        let productToEdit = extractData()

        network.patchData(product: productToEdit, id: id) { result in
            switch result {
            case .success():
                self.showAlert(title: Const.patchSuccess) {
                    self.dismiss(animated: true)
                }
            case .failure(let error):
                self.showAlert(title: Const.error, message: error.errorDescription)
            }
        }
    }
}

// MARK: - navigationBar

extension EditViewController {
    
    private func setupNavigationItems() {
        self.navigationItem.title = managementType?.type
        
        let cancelButton = UIBarButtonItem(title: Const.cancel, style: .plain, target: self, action: #selector(didTapCancelButton))
        navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(title: Const.done, style: .plain, target: self, action: #selector(didTapDoneButton))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapDoneButton() {
        self.showAlert(title: Const.really, cancel: Const.cancel, action: patchData)
    }
}
