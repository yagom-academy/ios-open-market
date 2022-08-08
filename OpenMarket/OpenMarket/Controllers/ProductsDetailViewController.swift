import UIKit

class ProductsDetailViewController: UIViewController, AlertMessage {   
    
    private let detailView = ProductsDetailView()
    private var productInfo: Page?
    
    var delegate: SendUpdateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(detailView)
        configureConstraint()
        addNavigationBarButton()
        getProductInfomation()
    }
}

// MARK: - Functions

extension ProductsDetailViewController {
    private func getProductInfomation() {
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(actionButtonDidTapped)
        )
    }
    
    private func deleteProduct(_ secret: String) {
        guard let productInfo = self.productInfo else { return }
        
        ProductsDataManager.shared.deleteData(
            identifier: UserInfo.identifier.rawValue,
            productID: productInfo.id,
            secret: secret
        ) { (data: Result<Page, IdentifierError>) in
            switch data {
            case .success(_):
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentAlertMessage(controller: self, message: "\(error)")
                }
            }
        }
    }
    
    private func getProductSecret(_ secret: String, completion: @escaping (String) -> Void) {
        guard let productInfo = self.productInfo else { return }
        
        ProductsDataManager.shared.getProductSecret(
            identifier: UserInfo.identifier.rawValue,
            secret: secret,
            productId: productInfo.id
        ) { (data: Result<String, IdentifierError>) in
            switch data {
            case .success(let productSecret):
                completion(productSecret)
            case .failure(let error):
                self.presentAlertMessage(controller: self, message: "\(error)")
            }
        }
    }
    
    private func deleteProcess() {
        let alert = UIAlertController(title: "암호", message: "암호를 입력하세요.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { action in
            guard let secret = alert.textFields?.first?.text else { return }
            self.getProductSecret(secret) { productSecret in
                self.deleteProduct(productSecret)
            }
        }
        alert.addTextField { textField in
            textField.placeholder = "비밀번호를 입력해주세요."
        }
        alert.addAction(action)
        
        self.present(alert, animated: true) {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(tap)
        }
    }
    
    private func updateProduct() {
        let registViewController = ProductsRegistViewController()
        registViewController.title = DetailViewTitle.update
        registViewController.registView.setProductInfomation(productInfo: self.productInfo)
        
        self.navigationController?.pushViewController(registViewController, animated: true)
    }
}

// MARK: - @objc Functions

extension ProductsDetailViewController {
    @objc private func didTappedOutside(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func actionButtonDidTapped() {
        let alert = UIAlertController()
        let updateAction = UIAlertAction(title: "수정", style: .default) { _ in
            self.updateProduct()
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.deleteProcess()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(updateAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
