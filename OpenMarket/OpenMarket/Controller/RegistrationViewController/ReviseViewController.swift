//
//  ReviseViewController.swift
//  OpenMarket
//
//  Created by song on 2022/05/29.
//

import UIKit

class ReviseViewController: UIViewController {
    private let product: Product
    private lazy var baseView = ProductRegistrationView(frame: view.frame)
    override func viewDidLoad() {
        super.viewDidLoad()
        view = baseView
        setupNavigationItems()
    }
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavigationItems() {
        self.navigationItem.title = "상품수정"
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
        navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapDoneButton))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapDoneButton() {
        let alert = UIAlertController(title: "Really?", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.dismiss(animated: true)
        }
        let noAction = UIAlertAction(title: "No", style: .destructive)
        alert.addActions(yesAction, noAction)
        present(alert, animated: true)
    }

}
