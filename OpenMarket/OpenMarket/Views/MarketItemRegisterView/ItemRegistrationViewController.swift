import UIKit

class ItemRegistrationViewController: UIViewController {
    private let registrationView = ItemRegisterAndModifyFormView()
    private let mode: Mode = .register

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

    func present(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }

    func dismiss() {
        dismiss(animated: true, completion: nil)
    }

    func informMode() -> Mode {
        return mode
    }
}
