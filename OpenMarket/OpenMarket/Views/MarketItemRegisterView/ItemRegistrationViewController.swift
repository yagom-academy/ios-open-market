import UIKit

class ItemRegistrationViewController: UIViewController {
    private let registrationView = ItemRegisterAndModifyFormView()
    private var manager = ItemRegisterAndModifyManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        registrationView.delegate = self
        registrationView.formViewDidLoad()
        view = registrationView
    }
}

extension ItemRegistrationViewController: ItemRegisterAndModifyFormViewDelegate {
    func setupNavigationBar() {
        navigationController?.navigationBar.scrollEdgeAppearance = registrationView.navigationBarAppearance
        self.navigationItem.rightBarButtonItem = registrationView.navigationBarDoneButton
        self.navigationItem.leftBarButtonItem = registrationView.navigationBarCanceButton
    }

    func register() {
        let currency =
            registrationView
            .currencySegmentedControl
            .titleForSegment(at: registrationView.currencySegmentedControl.selectedSegmentIndex)!
        manager.createItem(
            by: .register,
            registrationView.nameInputTextField.text,
            registrationView.descriptionInputTextView.text,
            registrationView.priceInputTextField.text,
            currency,
            registrationView.discountedPriceInputTextField.text,
            registrationView.stockInputTextField.text)
    }

    func dismiss() {
        dismiss(animated: true, completion: nil)
    }

    func presentImagePicker(_ imagePicker: UIImagePickerController) {
        present(imagePicker, animated: true)
    }
}
