import UIKit

class ProductRegisterViewController: UIViewController {

    lazy var stackView: ProductRegisterView = {
        let view = ProductRegisterView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(stackView)
        configureConstraint()
    }
}

// MARK: Stack View Configuration
extension ProductRegisterViewController {
    func configureConstraint() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
