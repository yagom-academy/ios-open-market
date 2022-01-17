import UIKit

class ProductRegisterViewController: UIViewController {
    let infoView = ProductInformationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "테스트"
        self.view.addSubview(infoView)
        
        [infoView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            infoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
