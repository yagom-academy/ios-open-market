import UIKit

class ProductsDetailViewController: UIViewController {

    private let detailView = ProductsDetailView()
    
    var delegate: SendUpdateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
        detailView.itemImageScrollView.delegate = self
        addNavigationBarButton()
        
        guard let delegate = delegate else { return }
        ProductsDataManager.shared.getData(productId: delegate.sendUpdate().id) { [weak self] (data: Page) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.detailView.setProductInfomation(data: data)
            }
        }
    }
    
    private func addNavigationBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonDidTapped))
    }
}

extension ProductsDetailViewController {
    @objc func actionButtonDidTapped() {
        let alert = UIAlertController()
        let updateAction = UIAlertAction(title: "수정", style: .default) { action in
            let registViewController = ProductsRegistViewController()
            registViewController.title = "상품수정"
            registViewController.registView.itemNameTextField.text = self.detailView.itemNameLabel.text
            registViewController.registView.itemPriceTextField.text = self.detailView.itemPriceLabel.text
            registViewController.registView.itemSaleTextField.text = self.detailView.itemSaleLabel.text
            registViewController.registView.itemStockTextField.text = self.detailView.itemStockLabel.text
            registViewController.registView.descriptionTextView.text = self.detailView.itemDescriptionTextView.text
            registViewController.registView.imageStackView.arrangedSubviews.last?.removeFromSuperview()
            self.navigationController?.pushViewController(registViewController, animated: true)
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { action in
            print(action)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { action in
            print(action)
        }
        alert.addAction(updateAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

extension ProductsDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x/scrollView.frame.size.width) + 1
        let totalPage = detailView.itemImageStackView.arrangedSubviews.count
        detailView.currentPage.text = "\(currentPage)/\(totalPage)"
    }
}
