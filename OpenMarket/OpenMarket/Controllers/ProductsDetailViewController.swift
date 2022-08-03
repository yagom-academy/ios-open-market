import UIKit

class ProductsDetailViewController: UIViewController {

    private let detailView = ProductsDetailView()
    
    var delegate: SendUpdateDelegate?
    
    var productInfo: Page?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(detailView)
        configureConstraint()
        addNavigationBarButton()
        
        guard let delegate = delegate else { return }
        ProductsDataManager.shared.getData(productId: delegate.sendUpdate().id) { [weak self] (data: Page) in
            guard let self = self else { return }
            self.productInfo = data
            DispatchQueue.main.async {
                self.title = self.productInfo?.name
                self.detailView.setProductInfomation(data: data)
            }
        }
    }
}

// MARK: - Functions

extension ProductsDetailViewController {
    private func configureConstraint() {
        detailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func addNavigationBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonDidTapped))
    }
    
    private func deleteProduct() {
        let alert = UIAlertController(title: "암호", message: "암호를 입력하세요.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { action in
            ProductsDataManager.shared.getProductSecret(identifier: UserInfo.identifier.rawValue, secret: (alert.textFields?.first?.text)!, productId: self.productInfo!.id) { data in
                ProductsDataManager.shared.deleteData(identifier: UserInfo.identifier.rawValue, productID: self.productInfo!.id, secret: data) { (data: Page) in
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
        alert.addTextField { textField in
            textField.placeholder = "비밀번호를 입력해주세요."
        }
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
    
    private func updateProduct() {
        let registViewController = ProductsRegistViewController()
        registViewController.title = DetailViewTitle.update.rawValue
        registViewController.registView.setProductInfomation(productInfo: self.productInfo)
        
        self.navigationController?.pushViewController(registViewController, animated: true)
    }
    
    @objc func actionButtonDidTapped() {
        let alert = UIAlertController()
        let updateAction = UIAlertAction(title: "수정", style: .default) { action in
            self.updateProduct()
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { action in
            self.deleteProduct()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(updateAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
