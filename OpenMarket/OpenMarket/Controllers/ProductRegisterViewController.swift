import UIKit

class ProductRegisterViewController: UIViewController {
    private let productRegistrationView = ProductInformationView()
    private let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productRegistrationView.delegate = self
        imagePickerController.delegate = self
        configUI()
    }
    
    private func configUI() {
        view.backgroundColor = .white
        configNavigationBar()
        configRegistrationView()
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
        print("등록") // TODO
    }
    
    private func configRegistrationView() {
        self.view.addSubview(productRegistrationView)
        
        [productRegistrationView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            productRegistrationView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            productRegistrationView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            productRegistrationView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            productRegistrationView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

extension ProductRegisterViewController: PickerPresenter {
    func presentImagePickerView() {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
}

extension ProductRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.editedImage] as? UIImage {
            productRegistrationView.addImageToImageStackView(from: image)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
