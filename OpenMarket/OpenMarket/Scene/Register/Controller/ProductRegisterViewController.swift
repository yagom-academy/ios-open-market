import UIKit

class ProductRegisterViewController: ProductManageViewController {
    private let productImagePickerController = ProductImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productRegisterManager.pickerPresenterDelegate = self
        productImagePickerController.pickerDelegate = self
        configNavigationBar()
    }
        
    private func configNavigationBar() {
        self.navigationItem.title = "상품등록"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didTapCancelButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDoneButton))
    }
    
    @objc private func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapDoneButton() {
        if !checkValidInput() {
            return
        }
        productRegisterManager.register()
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProductRegisterViewController: PickerPresenter {
    func presentImagePickerView() {
        productImagePickerController.sourceType = .photoLibrary
        productImagePickerController.allowsEditing = true
        self.present(productImagePickerController, animated: true, completion: nil)
    }
}

extension ProductRegisterViewController: PickerDelegate {
    func addImage(with image: UIImage) {
        if productRegisterManager.takeRegisteredImageCounts() < 5 {
            productRegisterManager.addImageToImageStackView(from: image, hasDeleteButton: true)
        }
        
        if productRegisterManager.takeRegisteredImageCounts() == 5 {
            productRegisterManager.setImageButtonHidden(state: true)
        }
    }
}
